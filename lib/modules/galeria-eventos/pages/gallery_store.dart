// stores/gallery_store.dart
import 'package:conexaoolivia/core/repositories/gallery_repository.dart';
import 'package:mobx/mobx.dart';
import '../models/gallery_event_model.dart';
import '../models/gallery_image_model.dart';
import '../models/image_upload_model.dart';

part 'gallery_store.g.dart';

class GalleryStore = GalleryStoreBase with _$GalleryStore;

abstract class GalleryStoreBase with Store {
  final IGalleryRepository _repository;

  GalleryStoreBase(this._repository);

  @observable
  ObservableList<GalleryEvent> galleryEvents = ObservableList<GalleryEvent>();

  @observable
  bool isLoading = false;

  @observable
  bool isAdmin = false;

  @observable
  String? errorMessage;

  @observable
  GalleryEvent? selectedEvent;

  @observable
  bool isUploadingImages = false;

  @observable
  double uploadProgress = 0.0;

  @computed
  bool get hasEvents => galleryEvents.isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @action
  Future<void> loadGalleryEvents() async {
    isLoading = true;
    errorMessage = null;

    try {
      final events = await _repository.getAllGalleryEvents();

      galleryEvents.clear();
      galleryEvents.addAll(events);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> checkAdminStatus() async {
    try {
      isAdmin = await _repository.isUserAdmin();
    } catch (e) {
      isAdmin = false;
    }
    print("IS ADMIN $isAdmin");
  }

  @action
  Future<void> loadGalleryEventById(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      selectedEvent = await _repository.getGalleryEventById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> createGalleryEvent(GalleryEvent event) async {
    isLoading = true;
    errorMessage = null;

    try {
      final newEvent = await _repository.createGalleryEvent(event);
      galleryEvents.add(newEvent);
      _sortEvents();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateGalleryEvent(GalleryEvent event) async {
    isLoading = true;
    errorMessage = null;

    try {
      final updatedEvent = await _repository.updateGalleryEvent(event);
      final index = galleryEvents.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        galleryEvents[index] = updatedEvent;
        _sortEvents();
      }
      selectedEvent = updatedEvent;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteGalleryEvent(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _repository.deleteGalleryEvent(id);
      galleryEvents.removeWhere((event) => event.id == id);
      if (selectedEvent?.id == id) {
        selectedEvent = null;
      }
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> uploadImages(String eventId, List<ImageUpload> images) async {
    isUploadingImages = true;
    uploadProgress = 0.0;
    errorMessage = null;

    try {
      final uploadedImages = await _repository.uploadImages(eventId, images);

      // Atualizar o evento com as novas imagens
      if (selectedEvent?.id == eventId) {
        final updatedImages = [...selectedEvent!.images, ...uploadedImages];
        selectedEvent = selectedEvent!.copyWith(images: updatedImages);
      }

      // Atualizar na lista também
      final eventIndex = galleryEvents.indexWhere((e) => e.id == eventId);
      if (eventIndex != -1) {
        final event = galleryEvents[eventIndex];
        final updatedImages = [...event.images, ...uploadedImages];
        galleryEvents[eventIndex] = event.copyWith(images: updatedImages);
      }

      uploadProgress = 1.0;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isUploadingImages = false;
      uploadProgress = 0.0;
    }
  }

  @action
  Future<bool> deleteImage(String imageId) async {
    errorMessage = null;

    try {
      await _repository.deleteImage(imageId);

      // Remover da lista de eventos
      for (int i = 0; i < galleryEvents.length; i++) {
        final event = galleryEvents[i];
        final updatedImages = event.images.where((img) => img.id != imageId).toList();
        if (updatedImages.length != event.images.length) {
          galleryEvents[i] = event.copyWith(images: updatedImages);
          break;
        }
      }

      // Remover do evento selecionado
      if (selectedEvent != null) {
        final updatedImages = selectedEvent!.images.where((img) => img.id != imageId).toList();
        if (updatedImages.length != selectedEvent!.images.length) {
          selectedEvent = selectedEvent!.copyWith(images: updatedImages);
        }
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  // NOVO: Deletar múltiplas imagens
  @action
  Future<bool> deleteMultipleImages(List<String> imageIds) async {
    errorMessage = null;

    try {
      if (imageIds.isEmpty) return true;

      await _repository.deleteMultipleImages(imageIds);

      // Atualizar eventos localmente
      for (int i = 0; i < galleryEvents.length; i++) {
        final event = galleryEvents[i];
        final updatedImages = event.images.where((img) => !imageIds.contains(img.id)).toList();
        if (updatedImages.length != event.images.length) {
          galleryEvents[i] = event.copyWith(images: updatedImages);
        }
      }

      // Atualizar evento selecionado
      if (selectedEvent != null) {
        final updatedImages = selectedEvent!.images.where((img) => !imageIds.contains(img.id)).toList();
        if (updatedImages.length != selectedEvent!.images.length) {
          selectedEvent = selectedEvent!.copyWith(images: updatedImages);
        }
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  @action
  Future<bool> updateImageOrder(String imageId, int newOrder) async {
    try {
      await _repository.updateImageOrder(imageId, newOrder);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  // NOVO: Definir imagem como thumbnail
  @action
  Future<bool> setImageAsThumbnail(String imageId) async {
    errorMessage = null;

    try {
      await _repository.setImageAsThumbnail(imageId);

      // Atualizar imagens localmente
      if (selectedEvent != null) {
        final updatedImages = selectedEvent!.images.map((img) {
          return img.copyWith(isThumbnail: img.id == imageId);
        }).toList();

        selectedEvent = selectedEvent!.copyWith(images: updatedImages);

        // Atualizar na lista de eventos também
        final eventIndex = galleryEvents.indexWhere((e) => e.id == selectedEvent!.id);
        if (eventIndex != -1) {
          galleryEvents[eventIndex] = selectedEvent!;
        }
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  // NOVO: Processar mudanças nas imagens durante edição
  @action
  Future<bool> processImageChanges(String eventId, List<ImageUpload> newImages, List<String> imagesToRemove) async {
    errorMessage = null;

    try {
      // 1. Deletar imagens marcadas para remoção
      if (imagesToRemove.isNotEmpty) {
        final deleteSuccess = await deleteMultipleImages(imagesToRemove);
        if (!deleteSuccess) return false;
      }

      // 2. Fazer upload das novas imagens
      if (newImages.isNotEmpty) {
        final uploadSuccess = await uploadImages(eventId, newImages);
        if (!uploadSuccess) return false;
      }

      // 3. Recarregar o evento atualizado
      await loadGalleryEventById(eventId);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setSelectedEvent(GalleryEvent? event) {
    selectedEvent = event;
  }

  @action
  void setUploadProgress(double progress) {
    uploadProgress = progress;
  }

  void _sortEvents() {
    galleryEvents.sort((a, b) => b.eventDate.compareTo(a.eventDate));
  }

  void dispose() {
    // Cleanup se necessário
  }
}