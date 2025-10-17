// pages/gallery_detail_page.dart
import 'package:conexaoolivia/modules/galeria-eventos/pages/gallery_form_store.dart';
import 'package:conexaoolivia/modules/galeria-eventos/pages/gallery_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/gallery_image_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../models/image_upload_model.dart';

class GalleryDetailPage extends StatefulWidget {
  const GalleryDetailPage({Key? key}) : super(key: key);

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  late final GalleryStore galleryStore;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    galleryStore = Modular.get<GalleryStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F9),
      body: Observer(
        builder: (_) {
          final event = galleryStore.selectedEvent;

          if (event == null) {
            return const Center(
              child: Text(
                'Evento não encontrado',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(event),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventInfo(event),
                      const SizedBox(height: 30),
                      _buildPhotosSection(event),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(event) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF8B6F9B),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Modular.to.pop(),
      ),
      actions: [
        Observer(
          builder: (_) => galleryStore.isAdmin
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!galleryStore.isUploadingImages)
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
                  onPressed: () => _showAddPhotosDialog(),
                  tooltip: 'Adicionar fotos',
                ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editEvent(),
                tooltip: 'Editar evento',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => _confirmDeleteEvent(),
                tooltip: 'Excluir evento',
              ),
            ],
          )
              : const SizedBox.shrink(),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF8B6F9B),
                const Color(0xFF8B6F9B).withOpacity(0.8),
              ],
            ),
          ),
          child: event.hasImages
              ? Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                // CORREÇÃO: Usar thumbnailImage em vez de código manual
                event.thumbnailImage?.imageUrl ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFF8B6F9B),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF8B6F9B),
                ),
              ),
              // Overlay para melhor legibilidade
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ],
          )
              : Container(
            color: const Color(0xFF8B6F9B),
            child: const Center(
              child: Icon(
                Icons.photo_library,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfo(event) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B6F9B).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6F9B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF8B6F9B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.formattedDate,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D1B2E),
                      ),
                    ),
                    Text(
                      'Data do evento',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE8E8E8)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B6F9B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Color(0xFF8B6F9B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D1B2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description!,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotosSection(event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B6F9B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.photo_library,
                color: Color(0xFF8B6F9B),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fotos (${event.images.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D1B2E),
                    ),
                  ),
                  Text(
                    'Toque para visualizar em tela cheia',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Observer(
          builder: (_) {
            if (galleryStore.isUploadingImages) {
              return _buildUploadProgress();
            }

            if (!event.hasImages) {
              return _buildNoPhotosState();
            }

            return _buildPhotoGrid(event.images);
          },
        ),
      ],
    );
  }

  Widget _buildUploadProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF8B6F9B).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'Enviando fotos...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B6F9B),
            ),
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (_) => LinearProgressIndicator(
              value: galleryStore.uploadProgress,
              backgroundColor: const Color(0xFF8B6F9B).withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B6F9B)),
            ),
          ),
          const SizedBox(height: 12),
          Observer(
            builder: (_) => Text(
              '${(galleryStore.uploadProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPhotosState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma foto encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'As fotos deste evento aparecerão aqui',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(List<GalleryImage> images) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return _buildPhotoItem(image, index, images);
      },
    );
  }

  Widget _buildPhotoItem(GalleryImage image, int index, List<GalleryImage> allImages) {
    return GestureDetector(
      onTap: () => _openPhotoViewer(index, allImages),
      onLongPress: galleryStore.isAdmin ? () => _showPhotoOptions(image) : null,
      child: Hero(
        tag: 'gallery_image_${image.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.network(
                  image.thumbnailUrl ?? image.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFF8B6F9B),
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                // Overlay sutil para efeito premium
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
                // NOVO: Indicador de foto de capa
                if (image.isThumbnail)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B6F9B),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPhotoViewer(int initialIndex, List<GalleryImage> images) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PhotoViewerPage(
          images: images,
          initialIndex: initialIndex,
          isAdmin: galleryStore.isAdmin,
          onDeletePhoto: (image) => _deletePhoto(image),
        ),
      ),
    );
  }

  void _showPhotoOptions(GalleryImage image) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            // NOVO: Opção para definir como capa
            if (!image.isThumbnail)
              ListTile(
                leading: const Icon(Icons.star, color: Color(0xFF8B6F9B)),
                title: const Text(
                  'Definir como foto de capa',
                  style: TextStyle(color: Color(0xFF8B6F9B)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _setImageAsThumbnail(image);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Excluir foto',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeletePhoto(image);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddPhotosDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              'Adicionar fotos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF8B6F9B)),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.pop(context);
                _pickImages(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF8B6F9B)),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImages(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      List<XFile> xFiles = [];

      if (source == ImageSource.camera) {
        final XFile? image = await _imagePicker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (image != null) xFiles.add(image);
      } else {
        xFiles = await _imagePicker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
      }

      if (xFiles.isNotEmpty) {
        await _processAndUploadImages(xFiles);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagens: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processAndUploadImages(List<XFile> xFiles) async {
    final List<ImageUpload> imageUploads = [];
    final event = galleryStore.selectedEvent!;

    for (final xFile in xFiles) {
      final file = File(xFile.path);
      final fileStats = await file.stat();
      final mimeType = lookupMimeType(xFile.path) ?? 'image/jpeg';

      imageUploads.add(ImageUpload(
        localPath: xFile.path,
        fileName: xFile.name,
        mimeType: mimeType,
        fileSize: fileStats.size,
      ));
    }

    final success = await galleryStore.uploadImages(event.id, imageUploads);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${imageUploads.length} foto(s) adicionada(s) com sucesso!'),
          backgroundColor: const Color(0xFF8B6F9B),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(galleryStore.errorMessage ?? 'Erro ao adicionar fotos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // NOVO: Definir imagem como thumbnail
  void _setImageAsThumbnail(GalleryImage image) async {
    final success = await galleryStore.setImageAsThumbnail(image.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de capa definida com sucesso!'),
          backgroundColor: Color(0xFF8B6F9B),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(galleryStore.errorMessage ?? 'Erro ao definir foto de capa'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editEvent() {
    final formStore = Modular.get<GalleryFormStore>();
    formStore.initializeWithEvent(galleryStore.selectedEvent!);

    Modular.to.pushNamed('/gallery/form').then((_) async {
      // Simplesmente recarregar o evento atual por ID
      if (galleryStore.selectedEvent?.id != null) {
        await galleryStore.loadGalleryEventById(galleryStore.selectedEvent!.id);
      }
    });
  }
  void _confirmDeleteEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text(
          'Tem certeza que deseja excluir este evento?\n\nTodas as fotos também serão removidas permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent() async {
    final success = await galleryStore.deleteGalleryEvent(galleryStore.selectedEvent!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento excluído com sucesso!'),
          backgroundColor: Color(0xFF8B6F9B),
        ),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(galleryStore.errorMessage ?? 'Erro ao excluir evento'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmDeletePhoto(GalleryImage image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir foto'),
        content: const Text('Tem certeza que deseja excluir esta foto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePhoto(image);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deletePhoto(GalleryImage image) async {
    final success = await galleryStore.deleteImage(image.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto excluída com sucesso!'),
          backgroundColor: Color(0xFF8B6F9B),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(galleryStore.errorMessage ?? 'Erro ao excluir foto'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Widget separado para o visualizador de fotos
class _PhotoViewerPage extends StatefulWidget {
  final List<GalleryImage> images;
  final int initialIndex;
  final bool isAdmin;
  final Function(GalleryImage) onDeletePhoto;

  const _PhotoViewerPage({
    required this.images,
    required this.initialIndex,
    required this.isAdmin,
    required this.onDeletePhoto,
  });

  @override
  State<_PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<_PhotoViewerPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} de ${widget.images.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.isAdmin)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'delete') {
                  _confirmDeleteCurrentPhoto();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Excluir foto', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final image = widget.images[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(image.imageUrl),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: 'gallery_image_${image.id}'),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 3,
                filterQuality: FilterQuality.high,
              );
            },
            itemCount: widget.images.length,
            loadingBuilder: (context, event) => Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8B6F9B),
                  strokeWidth: 2,
                ),
              ),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // Indicador de posição na parte inferior
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCurrentPhoto() {
    final currentImage = widget.images[_currentIndex];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Excluir foto',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tem certeza que deseja excluir esta foto?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDeletePhoto(currentImage);

              // Se foi a última foto, voltar para a tela anterior
              if (widget.images.length <= 1) {
                Navigator.pop(context);
              } else {
                // Ajustar o índice se necessário
                if (_currentIndex >= widget.images.length - 1) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}