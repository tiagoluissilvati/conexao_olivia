// core/repositories/profile_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../modules/profiles/models/profile_model.dart';

abstract class IProfileRepository {
  Future<List<Profile>> getAllProfiles();
  Future<Profile> getProfileById(String id);
  Future<Profile> getCurrentUserProfile();
  Future<Profile> updateProfile(Profile profile);
  Future<void> deleteProfile(String id);
  Future<bool> isUserAdmin();
  Future<String?> getCurrentUserId();
}

class ProfileRepository implements IProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository(this._supabase);

  @override
  Future<List<Profile>> getAllProfiles() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Profile.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar perfis: $e');
    }
  }

  @override
  Future<Profile> getProfileById(String id) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        throw Exception('Perfil não encontrado');
      }

      return Profile.fromJson(response);
    } catch (e) {
      if (e is PostgrestException) {
        throw Exception('Erro ao carregar perfil: ${e.message}');
      }
      throw Exception('Erro ao carregar perfil: $e');
    }
  }

  @override
  Future<Profile> getCurrentUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      return await getProfileById(userId);
    } catch (e) {
      throw Exception('Erro ao carregar perfil atual: $e');
    }
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    try {
      print('🔍 DEBUG updateProfile - ID: ${profile.id}');
      print('🔍 DEBUG updateProfile - Name: ${profile.name}');
      print('🔍 DEBUG updateProfile - Email: ${profile.email}');

      // Validação do ID
      if (profile.id.isEmpty) {
        throw Exception('ID do perfil não pode ser vazio');
      }

      // ✅ SOLUÇÃO: Criar um Map apenas com os campos atualizáveis
      // Não enviar 'id', 'created_at', 'email' (se não for alterável)
      final updateData = <String, dynamic>{
        'name': profile.name,
        'phone': profile.phone,
        'cpf': profile.cpf,
        'observacoes': profile.observacoes,
        'is_admin': profile.isAdmin,
        'needs_password_change': profile.needsPasswordChange,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Remover campos null se necessário (dependendo do schema)
      updateData.removeWhere((key, value) => value == null);

      print('📤 Dados sendo enviados: $updateData');

      // Fazer o UPDATE
      await _supabase
          .from('profiles')
          .update(updateData)
          .eq('id', profile.id);

      print('✅ Update executado com sucesso');

      // Buscar o perfil atualizado
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', profile.id)
          .single();

      print('✅ Perfil atualizado retornado com sucesso');
      return Profile.fromJson(response);

    } on PostgrestException catch (e) {
      print('❌ PostgrestException: ${e.message}');
      print('   Code: ${e.code}');
      print('   Details: ${e.details}');
      print('   Hint: ${e.hint}');

      // Mensagens mais específicas
      if (e.code == '42501') {
        throw Exception('Sem permissão para atualizar este perfil');
      } else if (e.code == '23505') {
        throw Exception('Email já está em uso');
      }

      throw Exception('Erro ao atualizar perfil: ${e.message}');
    } catch (e) {
      print('❌ Erro geral: $e');
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> deleteProfile(String id) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == id) {
        // Excluir própria conta
        await _supabase.from('profiles').delete().eq('id', id);

        // Deletar usuário (se houver RPC configurada)
        try {
          await _supabase.rpc('delete_user_account');
        } catch (e) {
          print('⚠️ RPC delete_user_account não disponível: $e');
        }

        return;
      }

      // Admin excluindo outro usuário
      await _supabase.from('profiles').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao excluir perfil: $e');
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

      return response['is_admin'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _supabase.auth.currentUser?.id;
  }
}