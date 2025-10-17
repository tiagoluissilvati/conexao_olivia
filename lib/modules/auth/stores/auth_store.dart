import 'package:conexaoolivia/core/services/supabase_admin_service.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../models/user_model.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  late final SupabaseAdminService _adminService  = SupabaseAdminService(
  supabaseUrl: "https://oixchzeanvnkiuqdrhlo.supabase.co",
  serviceRoleKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9peGNoemVhbnZua2l1cWRyaGxvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NzE2NzA3NCwiZXhwIjoyMDcyNzQzMDc0fQ.SYGajCmFZK6PNVTRNYS47lu0LQ04L5ye4buCvfmmxXI",
  );

  // Inicialize o admin service no construtor ou método de inicialização
  void initializeAdminService() {

    print('🔧 SupabaseAdminService inicializado');
  }

  @observable
  UserModel? currentUser;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isAuthenticated = false;

  @action
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      final response = await SupabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!.id);
        isAuthenticated = true;
        return true;
      }

      return false;
    } on AuthException catch (e) {
      errorMessage = _getErrorMessage(e.message);
      return false;
    } catch (e) {
      errorMessage = 'Erro inesperado. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String cpf,
    String? phone,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      // Verificar se email, CPF ou telefone já existem antes de tentar criar a conta
      final duplicateCheck = await _checkForDuplicates(email: email, cpf: cpf, phone: phone);
      if (duplicateCheck != null) {
        errorMessage = duplicateCheck;
        return false;
      }

      final response = await SupabaseService.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'cpf': cpf,
          'phone': phone,
        },
      );

      if (response.user != null) {
        // Criar perfil do usuário
        await _createUserProfileDirectly(
          userId: response.user!.id,
          email: email,
          name: name,
          cpf: cpf,
          phone: phone,
        );

        return true;
      }

      return false;
    } on AuthException catch (e) {
      errorMessage = _getErrorMessage(e.message);
      return false;
    } catch (e) {
      errorMessage = 'Erro inesperado. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signOut() async {
    try {
      isLoading = true;
      await SupabaseService.signOut();
      currentUser = null;
      isAuthenticated = false;
    } catch (e) {
      errorMessage = 'Erro ao sair. Tente novamente.';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> resetPassword(String email) async {
    try {
      print('🔑 === INICIANDO RESET DE SENHA NO STORE ===');
      print('   Email: $email');

      isLoading = true;
      errorMessage = null;

      // Verificar se o usuário existe antes de tentar resetar
      print('🔍 Verificando se usuário existe...');
      final userExists = await _adminService.verificarUsuarioExiste(email);

      if (!userExists) {
        print('❌ Usuário não encontrado');
        errorMessage = 'Email não encontrado em nosso sistema.';
        return false;
      }

      print('✅ Usuário encontrado, prosseguindo com reset...');

      // Usar o admin service para forçar a nova senha
      final success = await _adminService.forcarAtualizarSenhaPorEmail(email);

      if (success) {
        print('✅ === RESET DE SENHA CONCLUÍDO COM SUCESSO ===');
        print('   Email: $email');
        print('   Nova senha: 6 primeiros dígitos do CPF');
        return true;
      } else {
        print('❌ Falha no reset de senha');
        errorMessage = 'Erro ao redefinir senha. Tente novamente.';
        return false;
      }

    } catch (e, stackTrace) {
      print('❌ === ERRO NO RESET DE SENHA STORE ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      print('   Email tentativa: $email');

      // Definir mensagem de erro baseada no tipo de exceção
      if (e.toString().contains('Usuário não encontrado')) {
        errorMessage = 'Email não encontrado em nosso sistema.';
      } else if (e.toString().contains('CPF não encontrado')) {
        errorMessage = 'CPF não encontrado para este usuário. Entre em contato com o suporte.';
      } else if (e.toString().contains('Erro ao buscar usuário')) {
        errorMessage = 'Erro de conexão. Verifique sua internet e tente novamente.';
      } else {
        errorMessage = 'Erro ao redefinir senha. Tente novamente.';
      }

      return false;

    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> checkAuthState() async {
    final user = SupabaseService.currentUser;
    if (user != null) {
      await _loadUserProfile(user.id);
      isAuthenticated = true;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  // Método para verificar duplicatas de email, CPF e telefone
  Future<String?> _checkForDuplicates({
    required String email,
    required String cpf,
    String? phone,
  }) async {
    try {
      print('🔍 Verificando duplicatas para:');
      print('   Email: $email');
      print('   CPF: $cpf');
      print('   Telefone: ${phone ?? 'não fornecido'}');

      // Lista para armazenar as condições de busca
      List<String> duplicateMessages = [];

      // Verificar email duplicado
      final emailResponse = await SupabaseService.from('profiles')
          .select('email')
          .eq('email', email)
          .limit(1);

      if (emailResponse.isNotEmpty) {
        duplicateMessages.add('Este email já está cadastrado');
      }

      // Verificar CPF duplicado
      final cpfResponse = await SupabaseService.from('profiles')
          .select('cpf')
          .eq('cpf', cpf)
          .limit(1);

      if (cpfResponse.isNotEmpty) {
        duplicateMessages.add('Este CPF já está cadastrado');
      }

      // Verificar telefone duplicado (apenas se fornecido)
      if (phone != null && phone.isNotEmpty) {
        final phoneResponse = await SupabaseService.from('profiles')
            .select('phone')
            .eq('phone', phone)
            .limit(1);

        if (phoneResponse.isNotEmpty) {
          duplicateMessages.add('Este telefone já está cadastrado');
        }
      }

      // Retornar mensagem de erro se houver duplicatas
      if (duplicateMessages.isNotEmpty) {
        final errorMessage = duplicateMessages.join(' e ') + '.';
        print('❌ Duplicatas encontradas: $errorMessage');
        return errorMessage;
      }

      print('✅ Nenhuma duplicata encontrada');
      return null; // Nenhuma duplicata encontrada

    } catch (e) {
      print('❌ Erro ao verificar duplicatas: $e');
      // Em caso de erro na verificação, permitir continuar (pode ser problema de conexão)
      return null;
    }
  }

  // Método alternativo para verificação mais específica (opcional)
  Future<Map<String, bool>> checkDuplicatesDetailed({
    required String email,
    required String cpf,
    String? phone,
  }) async {
    try {
      Map<String, bool> result = {
        'emailExists': false,
        'cpfExists': false,
        'phoneExists': false,
      };

      // Verificar email
      final emailResponse = await SupabaseService.from('profiles')
          .select('email')
          .eq('email', email)
          .limit(1);

      result['emailExists'] = emailResponse.isNotEmpty;

      // Verificar CPF
      final cpfResponse = await SupabaseService.from('profiles')
          .select('cpf')
          .eq('cpf', cpf)
          .limit(1);

      result['cpfExists'] = cpfResponse.isNotEmpty;

      // Verificar telefone
      if (phone != null && phone.isNotEmpty) {
        final phoneResponse = await SupabaseService.from('profiles')
            .select('phone')
            .eq('phone', phone)
            .limit(1);

        result['phoneExists'] = phoneResponse.isNotEmpty;
      }

      return result;

    } catch (e) {
      print('❌ Erro ao verificar duplicatas detalhadas: $e');
      return {
        'emailExists': false,
        'cpfExists': false,
        'phoneExists': false,
      };
    }
  }

  Future<void> _createUserProfileDirectly({
    required String userId,
    required String email,
    required String name,
    required String cpf,
    String? phone,
  }) async {
    try {
      print('🔧 === CRIAÇÃO DE PERFIL - DEBUG CPF ===');
      print('   UserID: $userId');
      print('   Email: $email');
      print('   Nome: $name');
      print('   CPF RECEBIDO: "$cpf" (length: ${cpf.length})');
      print('   Telefone: ${phone ?? 'não fornecido'}');

      // IMPORTANTE: Verificar se o CPF não está vazio
      if (cpf.trim().isEmpty) {
        print('❌ ERRO: CPF está vazio!');
        throw Exception('CPF não pode estar vazio');
      }

      // PRIMEIRO: Verificar se o perfil já existe
      print('🔍 Verificando se perfil já existe...');
      final existingProfileResponse = await SupabaseService.from('profiles')
          .select()
          .eq('id', userId)
          .limit(1);

      if (existingProfileResponse.isNotEmpty) {
        print('⚠️ Perfil já existe, analisando dados...');

        final existingData = existingProfileResponse.first;
        print('📄 Dados existentes no banco:');
        existingData.forEach((key, value) {
          print('   $key: "$value" (${value.runtimeType})');
        });

        // Verificar se precisa atualizar o CPF
        final cpfNoBanco = existingData['cpf'];
        final needsUpdate = cpfNoBanco == null ||
            cpfNoBanco.toString().trim().isEmpty ||
            cpfNoBanco.toString() != cpf;

        if (needsUpdate) {
          print('🔄 Atualizando perfil existente com CPF...');

          final updateData = <String, dynamic>{
            'cpf': cpf.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          // Atualizar telefone se fornecido e diferente
          if (phone != null && phone.trim().isNotEmpty) {
            final phoneNoBanco = existingData['phone'];
            if (phoneNoBanco != phone.trim()) {
              updateData['phone'] = phone.trim();
            }
          }

          print('📝 Dados para atualização:');
          updateData.forEach((key, value) {
            print('   $key: "$value"');
          });

          final updatedProfile = await SupabaseService.from('profiles')
              .update(updateData)
              .eq('id', userId)
              .select()
              .single();

          print('✅ Perfil atualizado com sucesso!');
          print('📄 Dados após atualização:');
          updatedProfile.forEach((key, value) {
            print('   $key: "$value"');
          });

          currentUser = UserModel.fromJson(updatedProfile);
        } else {
          print('ℹ️ Perfil já tem todos os dados corretos, carregando...');
          currentUser = UserModel.fromJson(existingData);
        }

        print('✅ Perfil processado com sucesso');
        print('👤 currentUser.cpf: "${currentUser?.cpf}"');
        return;
      }

      // SEGUNDO: Se não existe, criar novo perfil
      print('➕ Perfil não existe, criando novo...');

      final profileData = {
        'id': userId,
        'email': email,
        'name': name,
        'cpf': cpf.trim(),
        'needs_password_change': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Adicionar telefone apenas se não for nulo/vazio
      if (phone != null && phone.trim().isNotEmpty) {
        profileData['phone'] = phone.trim();
      }

      print('📝 Dados que serão inseridos:');
      profileData.forEach((key, value) {
        print('   $key: "$value"');
      });

      final insertResponse = await SupabaseService.from('profiles')
          .insert(profileData)
          .select()
          .single();

      print('✅ Novo perfil criado com sucesso!');
      print('📄 Resposta do banco:');
      insertResponse.forEach((key, value) {
        print('   $key: "$value"');
      });

      // Verificar especificamente o CPF na resposta
      final cpfFromDb = insertResponse['cpf'];
      print('🆔 CPF retornado do banco: "$cpfFromDb"');

      if (cpfFromDb == null || cpfFromDb.toString().trim().isEmpty) {
        print('❌ ERRO: CPF não foi salvo corretamente no banco!');
        throw Exception('CPF não foi salvo no banco de dados');
      }

      currentUser = UserModel.fromJson(insertResponse);
      print('✅ === PERFIL CRIADO COM SUCESSO ===');

    } catch (e, stackTrace) {
      print('❌ === ERRO NA CRIAÇÃO/ATUALIZAÇÃO DO PERFIL ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');

      // Log mais detalhado para diferentes tipos de erro
      if (e.toString().contains('UserModel.fromJson')) {
        print('   ⚠️ ERRO ESPECÍFICO: Problema ao criar UserModel a partir dos dados do banco');
        print('   💡 SOLUÇÃO: Verifique se o UserModel está tratando campos null corretamente');
      }

      print('   Stack trace: $stackTrace');
      print('   UserID: $userId');
      print('   CPF: "$cpf"');

      // Tentar carregar perfil com fallback mais seguro
      try {
        print('🔄 Tentativa de recuperação...');
        final fallbackProfile = await SupabaseService.from('profiles')
            .select()
            .eq('id', userId)
            .single();

        print('📄 Dados para fallback:');
        fallbackProfile.forEach((key, value) {
          print('   $key: "$value" (${value.runtimeType})');
        });

        currentUser = UserModel.fromJson(fallbackProfile);
        print('✅ Recuperação bem-sucedida');
        return;

      } catch (fallbackError) {
        print('❌ Falha na recuperação: $fallbackError');

        // Último recurso: perfil mínimo local
        currentUser = UserModel(
          id: userId,
          email: email,
          name: name,
          cpf: cpf,
          phone: phone,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        print('⚠️ Usando perfil local temporário');
        throw Exception('Erro ao processar perfil no banco. Tente fazer login novamente.');
      }
    }
  }
  // Método direto sem verificações de RLS
  Future<void> _loadUserProfile(String userId) async {
    try {
      print('📄 === CARREGANDO PERFIL DO USUÁRIO ===');
      print('   UserID: $userId');

      final response = await SupabaseService.from('profiles')
          .select()
          .eq('id', userId)
          .single();

      print('📄 Dados recebidos do banco:');
      print('   Response: $response');

      currentUser = UserModel.fromJson(response);

      print('✅ Perfil carregado com sucesso');
      print('   Nome: ${currentUser?.name}');
      print('   Email: ${currentUser?.email}');
      print('   CPF: ${currentUser?.cpf}');
      print('   ID: ${currentUser?.id}');

    } catch (e, stackTrace) {
      print('❌ === ERRO AO CARREGAR PERFIL ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      print('   UserID tentativa: $userId');

      // Re-throw a exception para que o método que chamou saiba que houve erro
      throw Exception('Erro ao carregar perfil do usuário: $e');
    }
  }

  String _getErrorMessage(String error) {
    switch (error) {
      case 'Invalid login credentials':
        return 'Email ou senha incorretos.';
      case 'User already registered':
        return 'Este email já está cadastrado.';
      case 'Password should be at least 6 characters':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'Invalid email':
        return 'Email inválido.';
      default:
        return 'Erro inesperado. Tente novamente.';
    }
  }

  @action
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      print('🔐 === INICIANDO TROCA DE SENHA ===');
      print('   User ID: ${currentUser?.id}');

      // 1. Verificar senha atual fazendo re-login
      print('🔍 Verificando senha atual...');
      try {
        await SupabaseService.signIn(
          email: currentUser!.email,
          password: currentPassword,
        );
        print('✅ Senha atual verificada');
      } catch (e) {
        print('❌ Senha atual incorreta');
        errorMessage = 'Senha atual incorreta';
        return false;
      }

      // 2. Atualizar senha no Supabase Auth
      print('🔧 Atualizando senha...');
      final user = SupabaseService.currentUser;
      if (user == null) {
        errorMessage = 'Usuário não autenticado';
        return false;
      }

      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      print('✅ Senha atualizada no Auth');

      // 3. Remover flag de troca obrigatória
      print('🔧 Removendo flag de troca obrigatória...');
      await SupabaseService.from('profiles')
          .update({
        'needs_password_change': false,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', user.id);

      print('✅ Flag removida do perfil');

      // 4. Atualizar currentUser local
      if (currentUser != null) {
        currentUser = currentUser!.copyWith(
          needsPasswordChange: false,
        );
      }

      print('✅ === TROCA DE SENHA CONCLUÍDA ===');
      return true;

    } on AuthException catch (e) {
      print('❌ AuthException: ${e.message}');
      errorMessage = _getErrorMessage(e.message);
      return false;
    } catch (e, stackTrace) {
      print('❌ === ERRO NA TROCA DE SENHA ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');

      errorMessage = 'Erro ao alterar senha. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
    }
  }
}