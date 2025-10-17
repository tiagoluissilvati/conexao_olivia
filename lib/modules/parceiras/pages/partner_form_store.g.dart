// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PartnerFormStore on PartnerFormStoreBase, Store {
  Computed<bool>? _$isEditingComputed;

  @override
  bool get isEditing =>
      (_$isEditingComputed ??= Computed<bool>(() => super.isEditing,
              name: 'PartnerFormStoreBase.isEditing'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'PartnerFormStoreBase.isFormValid'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'PartnerFormStoreBase.hasError'))
          .value;
  Computed<bool>? _$hasLogoComputed;

  @override
  bool get hasLogo => (_$hasLogoComputed ??= Computed<bool>(() => super.hasLogo,
          name: 'PartnerFormStoreBase.hasLogo'))
      .value;
  Computed<bool>? _$hasPendingChangesComputed;

  @override
  bool get hasPendingChanges => (_$hasPendingChangesComputed ??= Computed<bool>(
          () => super.hasPendingChanges,
          name: 'PartnerFormStoreBase.hasPendingChanges'))
      .value;

  late final _$nameAtom =
      Atom(name: 'PartnerFormStoreBase.name', context: context);

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

  late final _$descriptionAtom =
      Atom(name: 'PartnerFormStoreBase.description', context: context);

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$addressAtom =
      Atom(name: 'PartnerFormStoreBase.address', context: context);

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$isActiveAtom =
      Atom(name: 'PartnerFormStoreBase.isActive', context: context);

  @override
  bool get isActive {
    _$isActiveAtom.reportRead();
    return super.isActive;
  }

  @override
  set isActive(bool value) {
    _$isActiveAtom.reportWrite(value, super.isActive, () {
      super.isActive = value;
    });
  }

  late final _$logoAtom =
      Atom(name: 'PartnerFormStoreBase.logo', context: context);

  @override
  ImageUpload? get logo {
    _$logoAtom.reportRead();
    return super.logo;
  }

  @override
  set logo(ImageUpload? value) {
    _$logoAtom.reportWrite(value, super.logo, () {
      super.logo = value;
    });
  }

  late final _$existingLogoUrlAtom =
      Atom(name: 'PartnerFormStoreBase.existingLogoUrl', context: context);

  @override
  String? get existingLogoUrl {
    _$existingLogoUrlAtom.reportRead();
    return super.existingLogoUrl;
  }

  @override
  set existingLogoUrl(String? value) {
    _$existingLogoUrlAtom.reportWrite(value, super.existingLogoUrl, () {
      super.existingLogoUrl = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'PartnerFormStoreBase.isLoading', context: context);

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
      Atom(name: 'PartnerFormStoreBase.errorMessage', context: context);

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

  late final _$editingPartnerAtom =
      Atom(name: 'PartnerFormStoreBase.editingPartner', context: context);

  @override
  Partner? get editingPartner {
    _$editingPartnerAtom.reportRead();
    return super.editingPartner;
  }

  @override
  set editingPartner(Partner? value) {
    _$editingPartnerAtom.reportWrite(value, super.editingPartner, () {
      super.editingPartner = value;
    });
  }

  late final _$PartnerFormStoreBaseActionController =
      ActionController(name: 'PartnerFormStoreBase', context: context);

  @override
  void setName(String value) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setName');
    try {
      return super.setName(value);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(String value) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setAddress');
    try {
      return super.setAddress(value);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsActive(bool value) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setIsActive');
    try {
      return super.setIsActive(value);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLogo(ImageUpload? image) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setLogo');
    try {
      return super.setLogo(image);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeLogo() {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.removeLogo');
    try {
      return super.removeLogo();
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.setError');
    try {
      return super.setError(error);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initializeWithPartner(Partner partner) {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.initializeWithPartner');
    try {
      return super.initializeWithPartner(partner);
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearForm() {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.clearForm');
    try {
      return super.clearForm();
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Partner buildPartner() {
    final _$actionInfo = _$PartnerFormStoreBaseActionController.startAction(
        name: 'PartnerFormStoreBase.buildPartner');
    try {
      return super.buildPartner();
    } finally {
      _$PartnerFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
description: ${description},
address: ${address},
isActive: ${isActive},
logo: ${logo},
existingLogoUrl: ${existingLogoUrl},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
editingPartner: ${editingPartner},
isEditing: ${isEditing},
isFormValid: ${isFormValid},
hasError: ${hasError},
hasLogo: ${hasLogo},
hasPendingChanges: ${hasPendingChanges}
    ''';
  }
}
