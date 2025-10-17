// stores/gallery_form_store.dart
import 'package:mobx/mobx.dart';
import '../models/gallery_event_model.dart';
import '../models/gallery_image_model.dart';
import '../models/image_upload_model.dart';

part 'gallery_form_store.g.dart';

class GalleryFormStore = GalleryFormStoreBase with _$GalleryFormStore;

abstract class GalleryFormStoreBase with Store {

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  GalleryEvent? editingEvent;

  @observable
  ObservableList<ImageUpload> selectedImages = ObservableList<ImageUpload>();

  // NOVO: Lista de imagens existentes (para edição)
  @observable
  ObservableList<GalleryImage> existingImages = ObservableList<GalleryImage>();

  // NOVO: Lista de imagens marcadas para remoção
  @observable
  ObservableList<String> imagesToRemove = ObservableList<String>();

  @computed
  bool get isEditing => editingEvent != null;

  @computed
  bool get isFormValid => title.trim().isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasImages => selectedImages.isNotEmpty || existingImages.isNotEmpty;

  // NOVO: Total de imagens (existentes + novas)
  @computed
  int get totalImagesCount => existingImages.length + selectedImages.length;

  @action
  void setTitle(String value) {
    title = value;
    _clearError();
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void _clearError() {
    errorMessage = null;
  }

  @action
  void addImages(List<ImageUpload> images) {
    selectedImages.addAll(images);
  }

  @action
  void removeImage(ImageUpload image) {
    selectedImages.remove(image);
  }

  @action
  void clearImages() {
    selectedImages.clear();
  }

  @action
  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = selectedImages.removeAt(oldIndex);
    selectedImages.insert(newIndex, item);
  }

  // NOVO: Marcar imagem existente para remoção
  @action
  void markImageForRemoval(String imageId) {
    imagesToRemove.add(imageId);
    existingImages.removeWhere((img) => img.id == imageId);
  }

  // NOVO: Cancelar remoção de imagem
  @action
  void cancelImageRemoval(String imageId) {
    imagesToRemove.remove(imageId);
    // Recarregar as imagens existentes do evento original
    if (editingEvent != null) {
      final originalImage = editingEvent!.images.firstWhere((img) => img.id == imageId);
      existingImages.add(originalImage);
    }
  }

  // NOVO: Definir imagem como thumbnail (apenas para existentes)
  @action
  void setImageAsThumbnail(String imageId) {
    // Remover thumbnail de todas as imagens existentes
    for (int i = 0; i < existingImages.length; i++) {
      existingImages[i] = existingImages[i].copyWith(isThumbnail: false);
    }

    // Definir a imagem selecionada como thumbnail
    final index = existingImages.indexWhere((img) => img.id == imageId);
    if (index != -1) {
      existingImages[index] = existingImages[index].copyWith(isThumbnail: true);
    }
  }

  @action
  void initializeWithEvent(GalleryEvent event) {
    editingEvent = event;
    title = event.title;
    description = event.description ?? '';
    selectedDate = event.eventDate;

    // NOVO: Carregar imagens existentes
    existingImages.clear();
    existingImages.addAll(event.images);

    // Limpar seleções anteriores
    selectedImages.clear();
    imagesToRemove.clear();
    errorMessage = null;
  }

  @action
  void clearForm() {
    editingEvent = null;
    title = '';
    description = '';
    selectedDate = DateTime.now();
    selectedImages.clear();
    existingImages.clear(); // NOVO
    imagesToRemove.clear(); // NOVO
    isLoading = false;
    errorMessage = null;
  }

  @action
  GalleryEvent buildGalleryEvent() {
    if (!isFormValid) {
      throw Exception('Formulário inválido');
    }

    final now = DateTime.now();

    if (isEditing) {
      return editingEvent!.copyWith(
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        eventDate: selectedDate,
        updatedAt: now,
        // NOVO: Usar as imagens existentes atualizadas
        images: existingImages.toList(),
      );
    } else {
      return GalleryEvent(
        id: '',
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        eventDate: selectedDate,
        createdBy: null,
        createdAt: now,
        updatedAt: now,
        images: [],
      );
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Título é obrigatório';
    }
    return null;
  }

  // NOVO: Validar se tem pelo menos uma imagem
  String? validateImages() {
    if (!isEditing && !hasImages) {
      return 'Selecione pelo menos uma foto para o evento';
    }
    if (isEditing && existingImages.isEmpty && selectedImages.isEmpty) {
      return 'O evento deve ter pelo menos uma foto';
    }
    return null;
  }

  @computed
  double get totalImageSize {
    return selectedImages.fold(0, (sum, image) => sum + image.fileSize) / (1024 * 1024);
  }

  @computed
  String get totalImageSizeFormatted {
    final size = totalImageSize;
    if (size < 1) {
      return '${(size * 1024).toStringAsFixed(0)} KB';
    }
    return '${size.toStringAsFixed(1)} MB';
  }

  // NOVO: Verificar se há mudanças pendentes
  @computed
  bool get hasPendingChanges {
    return selectedImages.isNotEmpty || imagesToRemove.isNotEmpty;
  }

  // NOVO: Obter imagem thumbnail atual (para exibição)
  @computed
  GalleryImage? get currentThumbnail {
    if (existingImages.isEmpty) return null;
    try {
      return existingImages.firstWhere((img) => img.isThumbnail);
    } catch (e) {
      return existingImages.isNotEmpty ? existingImages.first : null;
    }
  }
}