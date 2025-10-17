import 'dart:convert';
import 'package:conexaoolivia/core/services/supabase_service.dart';
import 'package:http/http.dart' as http;

class SupabaseAdminService {
  final String supabaseUrl;
  final String serviceRoleKey;

  SupabaseAdminService({
    required this.supabaseUrl,
    required this.serviceRoleKey,
  });

  /// Força atualização da senha de um usuário pelo e-mail.
  Future<bool> forcarAtualizarSenhaPorEmail(String email) async {
    try {
      print('🔧 === INICIANDO RESET DE SENHA ADMIN ===');
      print('   Email: $email');

      // 1. Buscar usuário pelo e-mail
      print('🔍 Buscando usuário por email...');
      final responseUser = await http.get(
        Uri.parse("$supabaseUrl/auth/v1/admin/users?email=$email"),
        headers: {
          "Authorization": "Bearer $serviceRoleKey",
          "apikey": serviceRoleKey,
        },
      );

      print('📡 Status da busca: ${responseUser.statusCode}');

      if (responseUser.statusCode != 200) {
        print('❌ Erro ao buscar usuário: ${responseUser.body}');
        throw Exception("Erro ao buscar usuário: ${responseUser.body}");
      }

      final data = jsonDecode(responseUser.body);
      final users = data['users'] as List?;

      print('📄 Dados recebidos: ${users?.length ?? 0} usuários encontrados');

      if (users == null || users.isEmpty) {
        print('❌ Usuário não encontrado com email: $email');
        throw Exception("Usuário não encontrado");
      }

      // Fazer o loop no array de usuários
      Map<String, dynamic>? exactUser;
      for (var user in users) {
        print('🔍 Verificando email: ${user['email']}');
        if (user['email'] == email) {
          exactUser = user;
          break;
        }
      }

      // Verificar se encontrou o usuário
      if (exactUser == null) {
        print('❌ Usuário não encontrado com email exato: $email');
        print('📋 Emails encontrados: ${users.map((u) => u['email']).join(', ')}');
        throw Exception("Usuário não encontrado");
      }

      final userId = exactUser['id'];
      print('✅ Usuário encontrado - ID: $userId');

      // 2. Buscar CPF do usuário
      print('🔍 Buscando CPF do usuário via HTTP...');
      String newPassword = "123456";
      try {
        final profileResponse = await http.get(
          Uri.parse("$supabaseUrl/rest/v1/profiles?id=eq.$userId&select=cpf"),
          headers: {
            'Authorization': 'Bearer $serviceRoleKey',
            'apikey': serviceRoleKey,
            'Content-Type': 'application/json',
          },
        );

        print('📡 Status busca profile: ${profileResponse.statusCode}');
        print('📄 Body busca profile: ${profileResponse.body}');

        if (profileResponse.statusCode != 200) {
          print('❌ Erro na busca do profile: ${profileResponse.body}');

          // FALLBACK: Tentar buscar por email
          print('🔄 Tentando buscar por email...');
          final profileByEmailResponse = await http.get(
            Uri.parse("$supabaseUrl/rest/v1/profiles?email=eq.$email&select=cpf"),
            headers: {
              'Authorization': 'Bearer $serviceRoleKey',
              'apikey': serviceRoleKey,
              'Content-Type': 'application/json',
            },
          );

          print('📡 Status busca por email: ${profileByEmailResponse.statusCode}');
          print('📄 Body busca por email: ${profileByEmailResponse.body}');

          if (profileByEmailResponse.statusCode != 200) {
            throw Exception("Erro ao buscar profile: ${profileResponse.body}");
          }

          final emailData = jsonDecode(profileByEmailResponse.body) as List;
          if (emailData.isEmpty || emailData.first['cpf'] == null) {
            throw Exception("CPF não encontrado por email");
          }

          final cpf = emailData.first['cpf'].toString().replaceAll(RegExp(r'[^0-9]'), '');
          print('✅ CPF encontrado por email: $cpf');

          if (cpf.length < 6) {
            throw Exception("CPF inválido - deve ter pelo menos 6 dígitos");
          }

          newPassword = cpf.substring(0, 6);
          print('🔑 Nova senha será: $newPassword');
        } else {
          // Busca por ID funcionou
          final profileData = jsonDecode(profileResponse.body) as List;

          if (profileData.isEmpty || profileData.first['cpf'] == null) {
            throw Exception("CPF não encontrado no profile");
          }

          final cpf = profileData.first['cpf'].toString().replaceAll(RegExp(r'[^0-9]'), '');
          print('✅ CPF encontrado por ID: $cpf');

          if (cpf.length < 6) {
            throw Exception("CPF inválido - deve ter pelo menos 6 dígitos");
          }

          newPassword = cpf.substring(0, 6);
          print('🔑 Nova senha será: $newPassword');
        }

        // 3. Atualizar senha do usuário
        print('🔧 Atualizando senha para os 6 primeiros dígitos do CPF...');
        final responseUpdate = await http.put(
          Uri.parse("$supabaseUrl/auth/v1/admin/users/$userId"),
          headers: {
            "Authorization": "Bearer $serviceRoleKey",
            "apikey": serviceRoleKey,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "password": newPassword,
          }),
        );

        print('📡 Status da atualização: ${responseUpdate.statusCode}');

        if (responseUpdate.statusCode != 200) {
          print('❌ Erro ao atualizar senha: ${responseUpdate.body}');
          throw Exception("Erro ao atualizar senha: ${responseUpdate.body}");
        }

        // 4. NOVO: Marcar flag de troca obrigatória no perfil
        print('🔧 Marcando flag de troca obrigatória no perfil...');
        final responseFlagUpdate = await http.patch(
          Uri.parse("$supabaseUrl/rest/v1/profiles?id=eq.$userId"),
          headers: {
            "Authorization": "Bearer $serviceRoleKey",
            "apikey": serviceRoleKey,
            "Content-Type": "application/json",
            "Prefer": "return=minimal",
          },
          body: jsonEncode({
            "needs_password_change": true,
            "updated_at": DateTime.now().toIso8601String(),
          }),
        );

        print('📡 Status atualização flag: ${responseFlagUpdate.statusCode}');

        if (responseFlagUpdate.statusCode == 204 || responseFlagUpdate.statusCode == 200) {
          print('✅ Flag de troca obrigatória marcada');
        } else {
          print('⚠️ Aviso: Não foi possível marcar flag (${responseFlagUpdate.statusCode})');
          // Não falha o processo por causa disso
        }

        print('✅ === SENHA ATUALIZADA COM SUCESSO ===');
        print('   Email: $email');
        print('   Nova senha: $newPassword');
        print('   Flag needs_password_change: true');
        return true;

      } catch (e) {
        print('❌ Erro ao buscar CPF: $e');
        if (e.toString().contains('No rows found')) {
          throw Exception("Usuário não possui perfil cadastrado");
        }
        rethrow;
      }

    } catch (e, stackTrace) {
      print('❌ === ERRO NO RESET DE SENHA ADMIN ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      print('   Email tentativa: $email');
      rethrow;
    }
  }

  /// Verifica se um usuário existe pelo email
  Future<bool> verificarUsuarioExiste(String email) async {
    try {
      print('🔍 Verificando se usuário existe: $email');

      final response = await http.get(
        Uri.parse("$supabaseUrl/auth/v1/admin/users?email=$email"),
        headers: {
          "Authorization": "Bearer $serviceRoleKey",
          "apikey": serviceRoleKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final users = data['users'] as List?;

        // Verificar se existe usuário com email exato
        final exactMatch = users?.any((user) => user['email'] == email) ?? false;

        print(exactMatch ? '✅ Usuário existe' : '❌ Usuário não encontrado');
        return exactMatch;
      }

      print('❌ Erro na verificação: ${response.statusCode}');
      return false;

    } catch (e) {
      print('❌ Erro ao verificar usuário: $e');
      return false;
    }
  }
}