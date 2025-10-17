// repositories/gallery_repository.dart
import 'dart:io';
import 'package:conexaoolivia/modules/galeria-eventos/models/gallery_event_model.dart';
import 'package:conexaoolivia/modules/galeria-eventos/models/gallery_image_model.dart';
import 'package:conexaoolivia/modules/galeria-eventos/models/image_upload_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

abstract class IGalleryRepository {
  Future<List<GalleryEvent>> getAllGalleryEvents();
  Future<GalleryEvent> getGalleryEventById(String id);
  Future<GalleryEvent> createGalleryEvent(GalleryEvent event);
  Future<GalleryEvent> updateGalleryEvent(GalleryEvent event);
  Future<void> deleteGalleryEvent(String id);
  Future<List<GalleryImage>> uploadImages(String eventId, List<ImageUpload> images);
  Future<void> deleteImage(String imageId);
  Future<void> deleteMultipleImages(List<String> imageIds); // NOVO
  Future<void> updateImageOrder(String imageId, int newOrder);
  Future<void> setImageAsThumbnail(String imageId); // NOVO
  Future<void> updateImageThumbnailStatus(String imageId, bool isThumbnail); // NOVO
  Future<bool> isUserAdmin();
}

class GalleryRepository implements IGalleryRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<GalleryEvent>> getAllGalleryEvents() async {
    try {
      final response = await _supabase
          .from('gallery_events')
          .select('''
            *,
            gallery_images (*)
          ''')
          .order('event_date', ascending: false);

      return (response as List)
          .map((json) => GalleryEvent.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar eventos da galeria: $e');
    }
  }

  @override
  Future<GalleryEvent> getGalleryEventById(String id) async {
    try {
      final response = await _supabase
          .from('gallery_events')
          .select('''
            *,
            gallery_images (*)
          ''')
          .eq('id', id)
          .order('display_order', referencedTable: 'gallery_images')
          .single();

      return GalleryEvent.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao carregar evento da galeria: $e');
    }
  }

  @override
  Future<GalleryEvent> createGalleryEvent(GalleryEvent event) async {
    try {
      final response = await _supabase
          .from('gallery_events')
          .insert(event.toJson())
          .select()
          .single();

      return GalleryEvent.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar evento da galeria: $e');
    }
  }

  @override
  Future<GalleryEvent> updateGalleryEvent(GalleryEvent event) async {
    try {
      final response = await _supabase
          .from('gallery_events')
          .update(event.toJson())
          .eq('id', event.id)
          .select()
          .single();

      return GalleryEvent.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar evento da galeria: $e');
    }
  }

  @override
  Future<void> deleteGalleryEvent(String id) async {
    try {
      // Primeiro, buscar todas as imagens do evento para deletar do storage
      final images = await _supabase
          .from('gallery_images')
          .select('image_path')
          .eq('gallery_event_id', id);

      // Deletar arquivos do storage
      for (final image in images) {
        await _supabase.storage
            .from('gallery-images')
            .remove([image['image_path']]);
      }

      // Deletar o evento (as imagens serão deletadas em cascata)
      await _supabase
          .from('gallery_events')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erro ao deletar evento da galeria: $e');
    }
  }

  @override
  Future<List<GalleryImage>> uploadImages(String eventId, List<ImageUpload> images) async {
    try {
      final List<GalleryImage> uploadedImages = [];

      // Verificar quantas imagens já existem no evento para definir a ordem correta
      final existingImagesCount = await _supabase
          .from('gallery_images')
          .select('id')
          .eq('gallery_event_id', eventId)
          .count();

      for (int i = 0; i < images.length; i++) {
        final imageUpload = images[i];
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final cleanFileName = imageUpload.fileName
            .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
            .toLowerCase();
        final fileName = '${eventId}_${timestamp}_${i}_$cleanFileName';
        final imagePath = 'events/$eventId/$fileName';

        String imageUrl;

        if (kIsWeb) {
          try {
            final xFile = XFile(imageUpload.localPath);
            final bytes = await xFile.readAsBytes();

            await _supabase.storage
                .from('gallery-images')
                .uploadBinary(imagePath, bytes, fileOptions: FileOptions(
              contentType: imageUpload.mimeType,
            ));

          } catch (e) {
            final xFile = XFile(imageUpload.localPath);
            final bytes = await xFile.readAsBytes();

            await _supabase.storage
                .from('gallery-images')
                .uploadBinary(imagePath, bytes);
          }

          imageUrl = _supabase.storage
              .from('gallery-images')
              .getPublicUrl(imagePath);
        } else {
          final file = File(imageUpload.localPath);

          await _supabase.storage
              .from('gallery-images')
              .upload(imagePath, file, fileOptions: FileOptions(
            contentType: imageUpload.mimeType,
          ));

          imageUrl = _supabase.storage
              .from('gallery-images')
              .getPublicUrl(imagePath);
        }

        final thumbnailUrl = imageUrl;

        // NOVO: Verificar se é a primeira imagem do evento para marcar como thumbnail
        final isFirstImage = existingImagesCount.count == 0 && i == 0;

        final imageData = {
          'gallery_event_id': eventId,
          'image_url': imageUrl,
          'image_path': imagePath,
          'thumbnail_url': thumbnailUrl,
          'original_name': imageUpload.fileName,
          'file_size': imageUpload.fileSize,
          'mime_type': imageUpload.mimeType,
          'display_order': existingImagesCount.count + i,
          'is_thumbnail': isFirstImage, // NOVO: Marcar primeira imagem como thumbnail
        };

        final response = await _supabase
            .from('gallery_images')
            .insert(imageData)
            .select()
            .single();

        uploadedImages.add(GalleryImage.fromJson(response));
      }

      return uploadedImages;
    } catch (e) {
      throw Exception('Erro ao fazer upload das imagens: $e');
    }
  }

  @override
  Future<void> deleteImage(String imageId) async {
    try {
      // Buscar informações da imagem
      final image = await _supabase
          .from('gallery_images')
          .select('image_path, gallery_event_id, is_thumbnail')
          .eq('id', imageId)
          .single();

      final eventId = image['gallery_event_id'];
      final wasThumbnail = image['is_thumbnail'] ?? false;

      // Deletar do storage
      await _supabase.storage
          .from('gallery-images')
          .remove([image['image_path']]);

      // Deletar do banco
      await _supabase
          .from('gallery_images')
          .delete()
          .eq('id', imageId);

      // NOVO: Se era thumbnail, definir a primeira imagem restante como nova thumbnail
      if (wasThumbnail) {
        final firstRemainingImage = await _supabase
            .from('gallery_images')
            .select('id')
            .eq('gallery_event_id', eventId)
            .order('display_order')
            .limit(1);

        if (firstRemainingImage.isNotEmpty) {
          await setImageAsThumbnail(firstRemainingImage.first['id']);
        }
      }

    } catch (e) {
      throw Exception('Erro ao deletar imagem: $e');
    }
  }

  // NOVO: Deletar múltiplas imagens
  @override
  Future<void> deleteMultipleImages(List<String> imageIds) async {
    try {
      if (imageIds.isEmpty) return;

      // Buscar informações das imagens
      final images = await _supabase
          .from('gallery_images')
          .select('id, image_path, gallery_event_id, is_thumbnail')
          .inFilter('id', imageIds);

      if (images.isEmpty) return;

      final eventId = images.first['gallery_event_id'];
      final pathsToDelete = images.map((img) => img['image_path'] as String).toList();
      final hadThumbnail = images.any((img) => img['is_thumbnail'] == true);

      // Deletar do storage
      if (pathsToDelete.isNotEmpty) {
        await _supabase.storage
            .from('gallery-images')
            .remove(pathsToDelete);
      }

      // Deletar do banco
      await _supabase
          .from('gallery_images')
          .delete()
          .inFilter('id', imageIds);

      // Se uma das imagens deletadas era thumbnail, definir nova thumbnail
      if (hadThumbnail) {
        final firstRemainingImage = await _supabase
            .from('gallery_images')
            .select('id')
            .eq('gallery_event_id', eventId)
            .order('display_order')
            .limit(1);

        if (firstRemainingImage.isNotEmpty) {
          await setImageAsThumbnail(firstRemainingImage.first['id']);
        }
      }

    } catch (e) {
      throw Exception('Erro ao deletar imagens: $e');
    }
  }

  @override
  Future<void> updateImageOrder(String imageId, int newOrder) async {
    try {
      await _supabase
          .from('gallery_images')
          .update({'display_order': newOrder})
          .eq('id', imageId);
    } catch (e) {
      throw Exception('Erro ao atualizar ordem da imagem: $e');
    }
  }

  // NOVO: Definir imagem como thumbnail (remove thumbnail das outras)
  @override
  Future<void> setImageAsThumbnail(String imageId) async {
    try {
      // Primeiro, buscar o evento da imagem
      final imageInfo = await _supabase
          .from('gallery_images')
          .select('gallery_event_id')
          .eq('id', imageId)
          .single();

      final eventId = imageInfo['gallery_event_id'];

      // Remover thumbnail de todas as imagens do evento
      await _supabase
          .from('gallery_images')
          .update({'is_thumbnail': false})
          .eq('gallery_event_id', eventId);

      // Definir a imagem selecionada como thumbnail
      await _supabase
          .from('gallery_images')
          .update({'is_thumbnail': true})
          .eq('id', imageId);

    } catch (e) {
      throw Exception('Erro ao definir imagem como thumbnail: $e');
    }
  }

  // NOVO: Atualizar status de thumbnail de uma imagem
  @override
  Future<void> updateImageThumbnailStatus(String imageId, bool isThumbnail) async {
    try {
      await _supabase
          .from('gallery_images')
          .update({'is_thumbnail': isThumbnail})
          .eq('id', imageId);
    } catch (e) {
      throw Exception('Erro ao atualizar status de thumbnail: $e');
    }
  }

  @override
  Future<bool> isUserAdmin() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final role = user.userMetadata?['role'];
      return role == 'admin';
    } catch (e) {
      return false;
    }
  }
}