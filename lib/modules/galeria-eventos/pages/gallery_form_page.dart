// pages/gallery_form_page.dart
import 'dart:io';
import 'package:conexaoolivia/modules/galeria-eventos/pages/gallery_form_store.dart';
import 'package:conexaoolivia/modules/galeria-eventos/pages/gallery_store.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../models/gallery_image_model.dart';
import '../models/image_upload_model.dart';
import '../../widgets/custom_text_field.dart';

class GalleryFormPage extends StatefulWidget {
  const GalleryFormPage({Key? key}) : super(key: key);

  @override
  State<GalleryFormPage> createState() => _GalleryFormPageState();
}

class _GalleryFormPageState extends State<GalleryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  late final GalleryStore galleryStore;
  late final GalleryFormStore formStore;

  @override
  void initState() {
    super.initState();
    galleryStore = Modular.get<GalleryStore>();
    formStore = Modular.get<GalleryFormStore>();

    _setupControllers();
  }

  void _setupControllers() {
    _titleController.text = formStore.title;
    _descriptionController.text = formStore.description;

    _titleController.addListener(() => formStore.setTitle(_titleController.text));
    _descriptionController.addListener(() => formStore.setDescription(_descriptionController.text));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: Observer(
          builder: (_) => Text(
            formStore.isEditing ? 'Editar Galeria' : 'Nova Galeria',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _handleBackPress(),
        ),
        elevation: 0,
      ),
      body: Observer(
        builder: (_) => Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF8B6F9B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Observer(
                builder: (_) => Icon(
                  formStore.isEditing ? Icons.edit_note : Icons.add_photo_alternate,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Título
            _buildFormCard(
              title: 'Título do Evento',
              child: CustomTextField(
                controller: _titleController,
                label: '',
                hint: 'Digite o título do evento da galeria',
                textCapitalization: TextCapitalization.words,
                validator: formStore.validateTitle,
              ),
            ),
            const SizedBox(height: 16),

            // Data
            _buildFormCard(
              title: 'Data do Evento',
              child: Observer(
                builder: (_) => GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF8B6F9B),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${formStore.selectedDate.day.toString().padLeft(2, '0')}/${formStore.selectedDate.month.toString().padLeft(2, '0')}/${formStore.selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Descrição
            _buildFormCard(
              title: 'Descrição (Opcional)',
              child: CustomTextField(
                controller: _descriptionController,
                label: '',
                hint: 'Descreva este momento especial...',
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 16),

            // NOVO: Imagens existentes (somente na edição)
            Observer(
              builder: (_) => formStore.isEditing && formStore.existingImages.isNotEmpty
                  ? _buildExistingImagesCard()
                  : const SizedBox.shrink(),
            ),

            // Seleção de novas imagens
            _buildImageSelectionCard(),
            const SizedBox(height: 16),

            // Galeria de novas imagens selecionadas
            Observer(
              builder: (_) => formStore.selectedImages.isNotEmpty
                  ? _buildSelectedImagesGrid()
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 30),

            // Botão salvar
            Observer(
              builder: (_) => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: formStore.isLoading ? null : _saveGalleryEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B6F9B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: formStore.isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
                    formStore.isEditing ? 'Atualizar Evento' : 'Criar Evento',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar erro se houver
            Observer(
              builder: (_) => formStore.hasError
                  ? Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formStore.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // NOVO: Widget para imagens existentes
  Widget _buildExistingImagesCard() {
    return Observer(
      builder: (_) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B6F9B).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Fotos Atuais',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B6F9B),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B6F9B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${formStore.existingImages.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B6F9B),
                    ),
                  ),
                ),
                const Spacer(),
                if (formStore.existingImages.length > 1)
                  TextButton.icon(
                    onPressed: () => _showThumbnailSelector(),
                    icon: const Icon(Icons.star, size: 16),
                    label: const Text('Definir Capa'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF8B6F9B),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: formStore.existingImages.length,
                itemBuilder: (context, index) {
                  final image = formStore.existingImages[index];
                  return _buildExistingImageThumbnail(image, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingImageThumbnail(GalleryImage image, int index) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: index < formStore.existingImages.length - 1 ? 8 : 0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: image.isThumbnail
                    ? const Color(0xFF8B6F9B).withOpacity(0.8)
                    : Colors.grey.withOpacity(0.3),
                width: image.isThumbnail ? 3 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image.thumbnailUrl ?? image.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),

          // Indicador de thumbnail
          if (image.isThumbnail)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6F9B),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),

          // Botão remover
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _confirmRemoveExistingImage(image),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B6F9B).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B6F9B),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildImageSelectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B6F9B).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                formStore.isEditing ? 'Adicionar Novas Fotos' : 'Fotos do Evento',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B6F9B),
                ),
              ),
              const Spacer(),
              Observer(
                builder: (_) => formStore.selectedImages.isNotEmpty
                    ? Text(
                  formStore.totalImageSizeFormatted,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (!kIsWeb) ...[
                Expanded(
                  child: _buildImagePickerButton(
                    icon: Icons.camera_alt,
                    label: 'Câmera',
                    source: ImageSource.camera,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: _buildImagePickerButton(
                  icon: Icons.photo_library,
                  label: kIsWeb ? 'Selecionar Fotos' : 'Galeria',
                  source: ImageSource.gallery,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerButton({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return ElevatedButton.icon(
      onPressed: () => _pickImages(source),
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B6F9B).withOpacity(0.1),
        foregroundColor: const Color(0xFF8B6F9B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color(0xFF8B6F9B).withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildSelectedImagesGrid() {
    return Observer(
      builder: (_) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B6F9B).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Novas Fotos (${formStore.selectedImages.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B6F9B),
                  ),
                ),
                const Spacer(),
                if (formStore.selectedImages.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => formStore.clearImages(),
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Limpar'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[400],
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: formStore.selectedImages.length,
              itemBuilder: (context, index) {
                final image = formStore.selectedImages[index];
                return _buildImageThumbnail(image, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(ImageUpload image, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF8B6F9B).withOpacity(0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: kIsWeb
                ? Image.network(
              image.localPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            )
                : Image.file(
              File(image.localPath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        // Botão remover
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => formStore.removeImage(image),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
        // Número da ordem
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: formStore.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B6F9B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != formStore.selectedDate) {
      formStore.setSelectedDate(picked);
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (kIsWeb && source == ImageSource.camera) {
        formStore.setError('Câmera não é suportada na versão web. Use a opção "Galeria".');
        return;
      }

      if (source == ImageSource.camera) {
        final XFile? image = await _imagePicker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );

        if (image != null) {
          await _processSelectedImages([image]);
        }
      } else {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );

        if (images.isNotEmpty) {
          await _processSelectedImages(images);
        }
      }
    } catch (e) {
      if (e.toString().contains('Platform._operatingSystem')) {
        formStore.setError('Seleção de imagens não suportada nesta plataforma. Use a versão mobile do app.');
      } else {
        formStore.setError('Erro ao selecionar imagens: ${e.toString()}');
      }
    }
  }

  Future<void> _processSelectedImages(List<XFile> xFiles) async {
    final List<ImageUpload> imageUploads = [];

    for (final xFile in xFiles) {
      int fileSize = 0;

      if (kIsWeb) {
        try {
          final bytes = await xFile.readAsBytes();
          fileSize = bytes.length;
        } catch (e) {
          fileSize = 0;
        }
      } else {
        final file = File(xFile.path);
        final fileStats = await file.stat();
        fileSize = fileStats.size;
      }

      final mimeType = lookupMimeType(xFile.path) ?? lookupMimeType(xFile.name) ?? 'image/jpeg';

      imageUploads.add(ImageUpload(
        localPath: xFile.path,
        fileName: xFile.name,
        mimeType: mimeType,
        fileSize: fileSize,
      ));
    }

    formStore.addImages(imageUploads);
  }

  // NOVO: Mostrar seletor de thumbnail
  // NOVO: Mostrar seletor de thumbnail com confirmação
  void _showThumbnailSelector() {
    String? selectedImageId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Selecione a foto de capa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toque na foto desejada e confirme',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Observer(
                    builder: (_) => GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: formStore.existingImages.length,
                      itemBuilder: (context, index) {
                        final image = formStore.existingImages[index];
                        final isCurrentThumbnail = image.isThumbnail;
                        final isSelected = selectedImageId == image.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedImageId == image.id) {
                                selectedImageId = null; // Deselecionar se já estava selecionado
                              } else {
                                selectedImageId = image.id;
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B6F9B)
                                    : isCurrentThumbnail
                                    ? const Color(0xFF8B6F9B).withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.3),
                                width: isSelected ? 4 : isCurrentThumbnail ? 2 : 1,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: const Color(0xFF8B6F9B).withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ] : null,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    image.thumbnailUrl ?? image.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  ),
                                ),

                                // Overlay de seleção
                                if (isSelected)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFF8B6F9B).withOpacity(0.2),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF8B6F9B),
                                        size: 40,
                                      ),
                                    ),
                                  ),

                                // Indicador de capa atual
                                if (isCurrentThumbnail && !isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B6F9B).withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),

                                // Label "Atual" para a capa atual
                                if (isCurrentThumbnail && !isSelected)
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'CAPA ATUAL',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Botões de ação
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedImageId != null
                              ? () async {
                            // Atualizar no form store
                            formStore.setImageAsThumbnail(selectedImageId!);

                            // Se estiver editando, também atualizar no gallery store
                            if (formStore.isEditing) {
                              final success = await galleryStore.setImageAsThumbnail(selectedImageId!);
                              if (!success) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(galleryStore.errorMessage ?? 'Erro ao definir foto de capa'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            }

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Foto de capa definida!'),
                                backgroundColor: Color(0xFF8B6F9B),
                              ),
                            );
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedImageId != null
                                ? const Color(0xFF8B6F9B)
                                : Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: selectedImageId != null ? 2 : 0,
                          ),
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                              color: selectedImageId != null ? Colors.white : Colors.grey[500],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NOVO: Confirmar remoção de imagem existente
  void _confirmRemoveExistingImage(GalleryImage image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover foto'),
        content: Text(
          image.isThumbnail
              ? 'Esta é a foto de capa atual. Tem certeza que deseja removê-la?\n\nUma nova foto de capa será selecionada automaticamente.'
              : 'Tem certeza que deseja remover esta foto?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              formStore.markImageForRemoval(image.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Foto marcada para remoção'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveGalleryEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!formStore.isFormValid) {
      formStore.setError('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    // Validar imagens
    final imageValidation = formStore.validateImages();
    if (imageValidation != null) {
      formStore.setError(imageValidation);
      return;
    }

    formStore.setLoading(true);

    try {
      final event = formStore.buildGalleryEvent();
      bool success;

      if (formStore.isEditing) {
        // Atualizar evento básico
        success = await galleryStore.updateGalleryEvent(event);

        if (success) {
          // Processar mudanças nas imagens
          success = await galleryStore.processImageChanges(
            event.id,
            formStore.selectedImages.toList(),
            formStore.imagesToRemove.toList(),
          );
        }
      } else {
        // Criar novo evento
        success = await galleryStore.createGalleryEvent(event);

        if (success && formStore.selectedImages.isNotEmpty) {
          final createdEvent = galleryStore.galleryEvents.last;

          success = await galleryStore.uploadImages(
            createdEvent.id,
            formStore.selectedImages.toList(),
          );
        }
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(formStore.isEditing
                ? 'Evento atualizado com sucesso!'
                : 'Evento criado com sucesso!'),
            backgroundColor: const Color(0xFF8B6F9B),
          ),
        );

        formStore.clearForm();
        Modular.to.pop();
      } else {
        formStore.setError(galleryStore.errorMessage ?? 'Erro ao salvar evento');
      }
    } catch (e) {
      formStore.setError('Erro inesperado: $e');
    } finally {
      formStore.setLoading(false);
    }
  }

  void _handleBackPress() {
    if (formStore.hasPendingChanges ||
        formStore.title.isNotEmpty ||
        formStore.description.isNotEmpty) {
      _showExitConfirmation();
    } else {
      formStore.clearForm();
      Modular.to.pop();
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text('Você tem alterações não salvas. Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              formStore.clearForm();
              Modular.to.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }
}