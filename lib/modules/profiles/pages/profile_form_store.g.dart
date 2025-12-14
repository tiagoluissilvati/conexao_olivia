// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileFormStore on ProfileFormStoreBase, Store {
  Computed<bool>? _$isEditingComputed;

  @override
  bool get isEditing =>
      (_$isEditingComputed ??= Computed<bool>(() => super.isEditing,
              name: 'ProfileFormStoreBase.isEditing'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'ProfileFormStoreBase.isFormValid'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'ProfileFormStoreBase.hasError'))
          .value;
  Computed<bool>? _$hasPendingChangesComputed;

  @override
  bool get hasPendingChanges => (_$hasPendingChangesComputed ??= Computed<bool>(
          () => super.hasPendingChanges,
          name: 'ProfileFormStoreBase.hasPendingChanges'))
      .value;

  late final _$nameAtom =
      Atom(name: 'ProfileFormStoreBase.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$emailAtom =
      Atom(name: 'ProfileFormStoreBase.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$phoneAtom =
      Atom(name: 'ProfileFormStoreBase.phone', context: context);

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$cpfAtom =
      Atom(name: 'ProfileFormStoreBase.cpf', context: context);

  @override
  String get cpf {
    _$cpfAtom.reportRead();
    return super.cpf;
  }

  @override
  set cpf(String value) {
    _$cpfAtom.reportWrite(value, super.cpf, () {
      super.cpf = value;
    });
  }

  late final _$observacoesAtom =
      Atom(name: 'ProfileFormStoreBase.observacoes', context: context);

  @override
  String get observacoes {
    _$observacoesAtom.reportRead();
    return super.observacoes;
  }

  @override
  set observacoes(String value) {
    _$observacoesAtom.reportWrite(value, super.observacoes, () {
      super.observacoes = value;
    });
  }

  late final _$isAdminAtom =
      Atom(name: 'ProfileFormStoreBase.isAdmin', context: context);

  @override
  bool get isAdmin {
    _$isAdminAtom.reportRead();
    return super.isAdmin;
  }

  @override
  set isAdmin(bool value) {
    _$isAdminAtom.reportWrite(value, super.isAdmin, () {
      super.isAdmin = value;
    });
  }

  late final _$needsPasswordChangeAtom =
      Atom(name: 'ProfileFormStoreBase.needsPasswordChange', context: context);

  @override
  bool get needsPasswordChange {
    _$needsPasswordChangeAtom.reportRead();
    return super.needsPasswordChange;
  }

  @override
  set needsPasswordChange(bool value) {
    _$needsPasswordChangeAtom.reportWrite(value, super.needsPasswordChange, () {
      super.needsPasswordChange = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'ProfileFormStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'ProfileFormStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$editingProfileAtom =
      Atom(name: 'ProfileFormStoreBase.editingProfile', context: context);

  @override
  Profile? get editingProfile {
    _$editingProfileAtom.reportRead();
    return super.editingProfile;
  }

  @override
  set editingProfile(Profile? value) {
    _$editingProfileAtom.reportWrite(value, super.editingProfile, () {
      super.editingProfile = value;
    });
  }

  late final _$isCurrentUserAdminAtom =
      Atom(name: 'ProfileFormStoreBase.isCurrentUserAdmin', context: context);

  @override
  bool get isCurrentUserAdmin {
    _$isCurrentUserAdminAtom.reportRead();
    return super.isCurrentUserAdmin;
  }

  @override
  set isCurrentUserAdmin(bool value) {
    _$isCurrentUserAdminAtom.reportWrite(value, super.isCurrentUserAdmin, () {
      super.isCurrentUserAdmin = value;
    });
  }

  late final _$ProfileFormStoreBaseActionController =
      ActionController(name: 'ProfileFormStoreBase', context: context);

  @override
  void setName(String value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setName');
    try {
      return super.setName(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCpf(String value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setCpf');
    try {
      return super.setCpf(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setObservacoes(String value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setObservacoes');
    try {
      return super.setObservacoes(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsAdmin(bool value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setIsAdmin');
    try {
      return super.setIsAdmin(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNeedsPasswordChange(bool value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setNeedsPasswordChange');
    try {
      return super.setNeedsPasswordChange(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setError');
    try {
      return super.setError(error);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentUserAdmin(bool value) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.setCurrentUserAdmin');
    try {
      return super.setCurrentUserAdmin(value);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initializeWithProfile(Profile profile, bool currentUserIsAdmin) {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.initializeWithProfile');
    try {
      return super.initializeWithProfile(profile, currentUserIsAdmin);
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearForm() {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.clearForm');
    try {
      return super.clearForm();
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Profile buildProfile() {
    final _$actionInfo = _$ProfileFormStoreBaseActionController.startAction(
        name: 'ProfileFormStoreBase.buildProfile');
    try {
      return super.buildProfile();
    } finally {
      _$ProfileFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
email: ${email},
phone: ${phone},
cpf: ${cpf},
observacoes: ${observacoes},
isAdmin: ${isAdmin},
needsPasswordChange: ${needsPasswordChange},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
editingProfile: ${editingProfile},
isCurrentUserAdmin: ${isCurrentUserAdmin},
isEditing: ${isEditing},
isFormValid: ${isFormValid},
hasError: ${hasError},
hasPendingChanges: ${hasPendingChanges}
    ''';
  }
}
