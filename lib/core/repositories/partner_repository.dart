// core/repositories/partner_repository.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../modules/parceiras/models/partner_model.dart';
import '../../modules/galeria-eventos/models/image_upload_model.dart';

abstract class IPartnerRepository {
  Future<List<Partner>> getAllPartners();
  Future<List<Partner>> getActivePartners();
  Future<Partner> getPartnerById(String id);
  Future<Partner> createPartner(Partner partner);
  Future<Partner> updatePartner(Partner partner);
  Future<void> deletePartner(String id);
  Future<bool> isUserAdmin();
  Future<Partner> uploadPartnerLogo(String partnerId, ImageUpload logo);
  Future<void> deleteLogo(String partnerId);
}

class PartnerRepository implements IPartnerRepository {
  final SupabaseClient _supabase;

  PartnerRepository(this._supabase);

  @override
  Future<List<Partner>> getAllPartners() async {
    try {
      final response = await _supabase
          .from('partners')
          .select()
          .order('name', ascending: true);

      return (response as List).map((json) => Partner.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar parceiras: $e');
    }
  }

  @override
  Future<List<Partner>> getActivePartners() async {
    try {
      final response = await _supabase
          .from('partners')
          .select()
          .eq('is_active', true)
          .order('name', ascending: true);

      return (response as List).map((json) => Partner.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar parceiras ativas: $e');
    }
  }

  @override
  Future<Partner> getPartnerById(String id) async {
    try {
      final response = await _supabase
          .from('partners')
          .select()
          .eq('id', id)
          .single();

      return Partner.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao carregar parceira: $e');
    }
  }

  @override
  Future<Partner> createPartner(Partner partner) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final partnerData = <String, dynamic>{
        'name': partner.name,
        'description': partner.description,
        'address': partner.address,
        'is_active': partner.isActive,
        'created_by': userId,
      };

      // Não enviar logo_url na criação (será null)
      // Não enviar id, created_at, updated_at (são gerados pelo banco)

      final response = await _supabase
          .from('partners')
          .insert(partnerData)
          .select()
          .single();

      return Partner.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar parceira: $e');
    }
  }

  @override
  Future<Partner> updatePartner(Partner partner) async {
    try {
      final response = await _supabase
          .from('partners')
          .update(partner.toJson())
          .eq('id', partner.id)
          .select()
          .single();

      return Partner.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao atualizar parceira: $e');
    }
  }

  @override
  Future<void> deletePartner(String id) async {
    try {
      final partner = await getPartnerById(id);

      // Deletar logo do storage se existir
      if (partner.logoUrl != null && partner.logoUrl!.isNotEmpty) {
        await _deleteLogoFromStorage(partner.logoUrl!);
      }

      // Deletar a parceira
      await _supabase.from('partners').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir parceira: $e');
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
  Future<Partner> uploadPartnerLogo(String partnerId, ImageUpload logo) async {
    try {
      final logoUrl = await _uploadLogo(partnerId, logo);

      // Atualizar parceira com a URL do logo
      final response = await _supabase
          .from('partners')
          .update({'logo_url': logoUrl})
          .eq('id', partnerId)
          .select()
          .single();

      return Partner.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao fazer upload do logo: $e');
    }
  }

  Future<String> _uploadLogo(String partnerId, ImageUpload imageUpload) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = imageUpload.fileName.split('.').last;
      final fileName = 'partner_${partnerId}_logo_$timestamp.$fileExtension';
      final filePath = 'partners/$partnerId/$fileName';

      // Ler os bytes do arquivo
      final Uint8List bytes = kIsWeb
          ? await _readBytesWeb(imageUpload.localPath)
          : await File(imageUpload.localPath).readAsBytes();

      // Upload para o Supabase Storage
      await _supabase.storage.from('partner-logos').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(
          contentType: imageUpload.mimeType,
          upsert: true,
        ),
      );

      // Obter URL pública
      final publicUrl = _supabase.storage.from('partner-logos').getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload do logo: $e');
    }
  }

  Future<Uint8List> _readBytesWeb(String url) async {
    throw UnimplementedError('Web upload requires different implementation');
  }

  @override
  Future<void> deleteLogo(String partnerId) async {
    try {
      final partner = await getPartnerById(partnerId);

      if (partner.logoUrl != null && partner.logoUrl!.isNotEmpty) {
        await _deleteLogoFromStorage(partner.logoUrl!);
      }

      // Atualizar parceira removendo a URL
      await _supabase
          .from('partners')
          .update({'logo_url': null})
          .eq('id', partnerId);
    } catch (e) {
      throw Exception('Erro ao deletar logo: $e');
    }
  }

  Future<void> _deleteLogoFromStorage(String logoUrl) async {
    try {
      final uri = Uri.parse(logoUrl);
      final pathSegments = uri.pathSegments;

      final bucketIndex = pathSegments.indexOf('partner-logos');
      if (bucketIndex == -1) return;

      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
      await _supabase.storage.from('partner-logos').remove([filePath]);
    } catch (e) {
      print('Aviso ao deletar logo do storage: $e');
    }
  }
}