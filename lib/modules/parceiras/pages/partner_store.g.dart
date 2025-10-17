// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PartnerStore on PartnerStoreBase, Store {
  Computed<bool>? _$hasPartnersComputed;

  @override
  bool get hasPartners =>
      (_$hasPartnersComputed ??= Computed<bool>(() => super.hasPartners,
              name: 'PartnerStoreBase.hasPartners'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'PartnerStoreBase.hasError'))
          .value;

  late final _$partnersAtom =
      Atom(name: 'PartnerStoreBase.partners', context: context);

  @override
  ObservableList<Partner> get partners {
    _$partnersAtom.reportRead();
    return super.partners;
  }

  @override
  set partners(ObservableList<Partner> value) {
    _$partnersAtom.reportWrite(value, super.partners, () {
      super.partners = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'PartnerStoreBase.isLoading', context: context);

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

  late final _$isAdminAtom =
      Atom(name: 'PartnerStoreBase.isAdmin', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: 'PartnerStoreBase.errorMessage', context: context);

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

  late final _$selectedPartnerAtom =
      Atom(name: 'PartnerStoreBase.selectedPartner', context: context);

  @override
  Partner? get selectedPartner {
    _$selectedPartnerAtom.reportRead();
    return super.selectedPartner;
  }

  @override
  set selectedPartner(Partner? value) {
    _$selectedPartnerAtom.reportWrite(value, super.selectedPartner, () {
      super.selectedPartner = value;
    });
  }

  late final _$isUploadingLogoAtom =
      Atom(name: 'PartnerStoreBase.isUploadingLogo', context: context);

  @override
  bool get isUploadingLogo {
    _$isUploadingLogoAtom.reportRead();
    return super.isUploadingLogo;
  }

  @override
  set isUploadingLogo(bool value) {
    _$isUploadingLogoAtom.reportWrite(value, super.isUploadingLogo, () {
      super.isUploadingLogo = value;
    });
  }

  late final _$loadPartnersAsyncAction =
      AsyncAction('PartnerStoreBase.loadPartners', context: context);

  @override
  Future<void> loadPartners() {
    return _$loadPartnersAsyncAction.run(() => super.loadPartners());
  }

  late final _$_checkAdminStatusAsyncAction =
      AsyncAction('PartnerStoreBase._checkAdminStatus', context: context);

  @override
  Future<void> _checkAdminStatus() {
    return _$_checkAdminStatusAsyncAction.run(() => super._checkAdminStatus());
  }

  late final _$loadPartnerByIdAsyncAction =
      AsyncAction('PartnerStoreBase.loadPartnerById', context: context);

  @override
  Future<void> loadPartnerById(String id) {
    return _$loadPartnerByIdAsyncAction.run(() => super.loadPartnerById(id));
  }

  late final _$createPartnerAsyncAction =
      AsyncAction('PartnerStoreBase.createPartner', context: context);

  @override
  Future<bool> createPartner(Partner partner, {ImageUpload? logo}) {
    return _$createPartnerAsyncAction
        .run(() => super.createPartner(partner, logo: logo));
  }

  late final _$updatePartnerAsyncAction =
      AsyncAction('PartnerStoreBase.updatePartner', context: context);

  @override
  Future<bool> updatePartner(Partner partner, {ImageUpload? logo}) {
    return _$updatePartnerAsyncAction
        .run(() => super.updatePartner(partner, logo: logo));
  }

  late final _$deletePartnerAsyncAction =
      AsyncAction('PartnerStoreBase.deletePartner', context: context);

  @override
  Future<bool> deletePartner(String id) {
    return _$deletePartnerAsyncAction.run(() => super.deletePartner(id));
  }

  late final _$deleteLogoAsyncAction =
      AsyncAction('PartnerStoreBase.deleteLogo', context: context);

  @override
  Future<bool> deleteLogo(String partnerId) {
    return _$deleteLogoAsyncAction.run(() => super.deleteLogo(partnerId));
  }

  late final _$PartnerStoreBaseActionController =
      ActionController(name: 'PartnerStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$PartnerStoreBaseActionController.startAction(
        name: 'PartnerStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$PartnerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPartner(Partner? partner) {
    final _$actionInfo = _$PartnerStoreBaseActionController.startAction(
        name: 'PartnerStoreBase.setSelectedPartner');
    try {
      return super.setSelectedPartner(partner);
    } finally {
      _$PartnerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
partners: ${partners},
isLoading: ${isLoading},
isAdmin: ${isAdmin},
errorMessage: ${errorMessage},
selectedPartner: ${selectedPartner},
isUploadingLogo: ${isUploadingLogo},
hasPartners: ${hasPartners},
hasError: ${hasError}
    ''';
  }
}
