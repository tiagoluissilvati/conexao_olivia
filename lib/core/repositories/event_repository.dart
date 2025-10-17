// repositories/event_repository.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:conexaoolivia/modules/galeria-eventos/models/image_upload_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../modules/eventos/models/event_model.dart';
import '../../modules/eventos/pages/event_store.dart';

abstract class IEventRepository {
  Future<List<Event>> getAllEvents();
  Future<List<Event>> getFutureEvents();
  Future<Event> getEventById(String id);
  Future<Event> createEvent(Event event);
  Future<Event> updateEvent(Event event);
  Future<void> deleteEvent(String id);
  Future<bool> isUserAdmin();
  Future<void> clearFeaturedEvents({String? exceptId});
  Future<Event> uploadEventBanners(
      String eventId, {
        ImageUpload? bannerCarousel,
        ImageUpload? bannerLarge,
      });
  Future<void> deleteBanner(String eventId, BannerType bannerType);
}

class EventRepository implements IEventRepository {
  final SupabaseClient _supabase;

  EventRepository(this._supabase);

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .order('event_date', ascending: true);

      return (response as List).map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar eventos: $e');
    }
  }

  @override
  Future<List<Event>> getFutureEvents() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final response = await _supabase
          .from('events')
          .select()
          .gte('event_date', today.toIso8601String())
          .order('event_date', ascending: true);

      return (response as List).map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar eventos futuros: $e');
    }
  }

  @override
  Future<Event> getEventById(String id) async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .eq('id', id)
          .single();

      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao carregar evento: $e');
    }
  }

  @override
  Future<Event> createEvent(Event event) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final eventData = event.toJson();
      eventData['created_by'] = userId;

      final response = await _supabase
          .from('events')
          .insert(eventData)
          .select()
          .single();

      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar evento: $e');
    }
  }

  @override
  Future<Event> updateEvent(Event event) async {
    try {
      final response = await _supabase
          .from('events')
          .update(event.toJson())
          .eq('id', event.id)
          .select()
          .single();

      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar evento: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      // Buscar o evento para obter as URLs dos banners
      final event = await getEventById(id);

      // Deletar banners do storage se existirem
      if (event.bannerCarouselUrl != null && event.bannerCarouselUrl!.isNotEmpty) {
        await _deleteBannerFromStorage(event.bannerCarouselUrl!);
      }
      if (event.bannerLargeUrl != null && event.bannerLargeUrl!.isNotEmpty) {
        await _deleteBannerFromStorage(event.bannerLargeUrl!);
      }

      // Deletar o evento
      await _supabase.from('events').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir evento: $e');
    }
  }

  @override
  Future<bool> isUserAdmin() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('profiles')
          .select('is_admin')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return false;
      return response['is_admin'] == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearFeaturedEvents({String? exceptId}) async {
    try {
      var query = _supabase.from('events').update({'is_featured': false});

      if (exceptId != null) {
        query = query.neq('id', exceptId);
      }

      await query.eq('is_featured', true);
    } catch (e) {
      throw Exception('Erro ao limpar eventos em destaque: $e');
    }
  }

  @override
  Future<Event> uploadEventBanners(
      String eventId, {
        ImageUpload? bannerCarousel,
        ImageUpload? bannerLarge,
      }) async {
    try {
      String? carouselUrl;
      String? largeUrl;

      // Upload do banner carrossel
      if (bannerCarousel != null) {
        carouselUrl = await _uploadBanner(
          eventId,
          bannerCarousel,
          'carousel',
        );
      }

      // Upload do banner grande
      if (bannerLarge != null) {
        largeUrl = await _uploadBanner(
          eventId,
          bannerLarge,
          'large',
        );
      }

      // Atualizar evento com as URLs
      final updateData = <String, dynamic>{};
      if (carouselUrl != null) updateData['banner_carousel_url'] = carouselUrl;
      if (largeUrl != null) updateData['banner_large_url'] = largeUrl;

      if (updateData.isNotEmpty) {
        final response = await _supabase
            .from('events')
            .update(updateData)
            .eq('id', eventId)
            .select()
            .single();

        return Event.fromJson(response);
      }

      return await getEventById(eventId);
    } catch (e) {
      throw Exception('Erro ao fazer upload dos banners: $e');
    }
  }

  Future<String> _uploadBanner(
      String eventId,
      ImageUpload imageUpload,
      String bannerType,
      ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = imageUpload.fileName.split('.').last;
      final fileName = 'event_${eventId}_${bannerType}_$timestamp.$fileExtension';
      final filePath = 'events/$eventId/banners/$fileName';

      // Ler os bytes do arquivo
      final Uint8List bytes = kIsWeb
          ? await _readBytesWeb(imageUpload.localPath)
          : await File(imageUpload.localPath).readAsBytes();

      // Upload para o Supabase Storage
      await _supabase.storage.from('event-banners').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(
          contentType: imageUpload.mimeType,
          upsert: true,
        ),
      );

      // Obter URL pública
      final publicUrl = _supabase.storage.from('event-banners').getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload do banner $bannerType: $e');
    }
  }

  Future<Uint8List> _readBytesWeb(String url) async {
    // Para web, a URL já é um blob URL
    throw UnimplementedError('Web upload requires different implementation');
  }

  @override
  Future<void> deleteBanner(String eventId, BannerType bannerType) async {
    try {
      final event = await getEventById(eventId);

      final bannerUrl = bannerType == BannerType.carousel
          ? event.bannerCarouselUrl
          : event.bannerLargeUrl;

      if (bannerUrl != null && bannerUrl.isNotEmpty) {
        await _deleteBannerFromStorage(bannerUrl);
      }

      // Atualizar o evento removendo a URL
      final updateData = bannerType == BannerType.carousel
          ? {'banner_carousel_url': null}
          : {'banner_large_url': null};

      await _supabase.from('events').update(updateData).eq('id', eventId);
    } catch (e) {
      throw Exception('Erro ao deletar banner: $e');
    }
  }

  Future<void> _deleteBannerFromStorage(String bannerUrl) async {
    try {
      // Extrair o path do storage da URL
      final uri = Uri.parse(bannerUrl);
      final pathSegments = uri.pathSegments;

      // Encontrar o índice onde começa o path do arquivo
      final bucketIndex = pathSegments.indexOf('event-banners');
      if (bucketIndex == -1) return;

      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');

      await _supabase.storage.from('event-banners').remove([filePath]);
    } catch (e) {
      // Ignorar erros ao deletar arquivo (pode já ter sido deletado)
      print('Aviso ao deletar banner do storage: $e');
    }
  }
}