// modules/profiles/pages/profile_form_store.dart
import 'package:mobx/mobx.dart';
import '../models/profile_model.dart';

part 'profile_form_store.g.dart';

class ProfileFormStore = ProfileFormStoreBase with _$ProfileFormStore;

abstract class ProfileFormStoreBase with Store {
  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String phone = '';

  @observable
  String cpf = '';

  @observable
  String observacoes = '';

  @observable
  bool isAdmin = false;

  @observable
  bool needsPasswordChange = false;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  Profile? editingProfile;

  @observable
  bool isCurrentUserAdmin = false;

  @computed
  bool get isEditing => editingProfile != null;

  @computed
  bool get isFormValid =>
      name.trim().isNotEmpty &&
          email.trim().isNotEmpty &&
          _isValidEmail(email.trim());

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasPendingChanges {
    if (!isEditing) return name.isNotEmpty || email.isNotEmpty;

    final profile = editingProfile!;
    return name != (profile.name ?? '') ||
        email != profile.email ||
        phone != (profile.phone ?? '') ||
        cpf != (profile.cpf ?? '') ||
        (isCurrentUserAdmin && observacoes != (profile.observacoes ?? '')) ||
        isAdmin != profile.isAdmin ||
        needsPasswordChange != profile.needsPasswordChange;
  }

  @action
  void setName(String value) {
    name = value;
    _clearError();
  }

  @action
  void setEmail(String value) {
    email = value;
    _clearError();
  }

  @action
  void setPhone(String value) {
    // Remover formatação
    phone = value.replaceAll(RegExp(r'\D'), '');
  }

  @action
  void setCpf(String value) {
    // Remover formatação
    cpf = value.replaceAll(RegExp(r'\D'), '');
  }

  @action
  void setObservacoes(String value) {
    observacoes = value;
  }

  @action
  void setIsAdmin(bool value) {
    isAdmin = value;
  }

  @action
  void setNeedsPasswordChange(bool value) {
    needsPasswordChange = value;
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
  void setCurrentUserAdmin(bool value) {
    isCurrentUserAdmin = value;
  }

  @action
  void _clearError() {
    errorMessage = null;
  }

  @action
  void initializeWithProfile(Profile profile, bool currentUserIsAdmin) {
    editingProfile = profile;
    isCurrentUserAdmin = currentUserIsAdmin;
    name = profile.name ?? '';
    email = profile.email;
    phone = profile.phone ?? '';
    cpf = profile.cpf ?? '';
    // Observações só carrega se for admin
    observacoes = currentUserIsAdmin ? (profile.observacoes ?? '') : '';
    isAdmin = profile.isAdmin;
    needsPasswordChange = profile.needsPasswordChange;
    errorMessage = null;
  }

  @action
  void clearForm() {
    editingProfile = null;
    name = '';
    email = '';
    phone = '';
    cpf = '';
    observacoes = '';
    isAdmin = false;
    needsPasswordChange = false;
    isLoading = false;
    errorMessage = null;
    isCurrentUserAdmin = false;
  }

  @action
  Profile buildProfile() {
    if (!isFormValid) {
      throw Exception('Formulário inválido');
    }

    final now = DateTime.now();

    return editingProfile!.copyWith(
      name: name.trim().isEmpty ? null : name.trim(),
      email: email.trim(),
      phone: phone.trim().isEmpty ? null : phone.trim(),
      cpf: cpf.trim().isEmpty ? null : cpf.trim(),
      // Observações só atualiza se for admin
      observacoes: isCurrentUserAdmin
          ? (observacoes.trim().isEmpty ? null : observacoes.trim())
          : editingProfile!.observacoes, // Mantém o valor original se não for admin
      isAdmin: isAdmin,
      needsPasswordChange: needsPasswordChange,
      updatedAt: now,
    );
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    if (!_isValidEmail(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  String? validateCpf(String? value) {
    if (value == null || value.isEmpty) return null;

    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verificar se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleaned)) {
      return 'CPF inválido';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;

    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10 && cleaned.length != 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String formatCpf(String cpf) {
    final cleaned = cpf.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 11) return cpf;
    return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6, 9)}-${cleaned.substring(9, 11)}';
  }

  String formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 11) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 7)}-${cleaned.substring(7)}';
    } else if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }
}