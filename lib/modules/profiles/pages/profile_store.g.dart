// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on ProfileStoreBase, Store {
  Computed<bool>? _$hasProfilesComputed;

  @override
  bool get hasProfiles =>
      (_$hasProfilesComputed ??= Computed<bool>(() => super.hasProfiles,
              name: 'ProfileStoreBase.hasProfiles'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'ProfileStoreBase.hasError'))
          .value;

  late final _$profilesAtom =
      Atom(name: 'ProfileStoreBase.profiles', context: context);

  @override
  ObservableList<Profile> get profiles {
    _$profilesAtom.reportRead();
    return super.profiles;
  }

  @override
  set profiles(ObservableList<Profile> value) {
    _$profilesAtom.reportWrite(value, super.profiles, () {
      super.profiles = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'ProfileStoreBase.isLoading', context: context);

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
      Atom(name: 'ProfileStoreBase.isAdmin', context: context);

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
      Atom(name: 'ProfileStoreBase.errorMessage', context: context);

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

  late final _$selectedProfileAtom =
      Atom(name: 'ProfileStoreBase.selectedProfile', context: context);

  @override
  Profile? get selectedProfile {
    _$selectedProfileAtom.reportRead();
    return super.selectedProfile;
  }

  @override
  set selectedProfile(Profile? value) {
    _$selectedProfileAtom.reportWrite(value, super.selectedProfile, () {
      super.selectedProfile = value;
    });
  }

  late final _$currentUserProfileAtom =
      Atom(name: 'ProfileStoreBase.currentUserProfile', context: context);

  @override
  Profile? get currentUserProfile {
    _$currentUserProfileAtom.reportRead();
    return super.currentUserProfile;
  }

  @override
  set currentUserProfile(Profile? value) {
    _$currentUserProfileAtom.reportWrite(value, super.currentUserProfile, () {
      super.currentUserProfile = value;
    });
  }

  late final _$currentUserIdAtom =
      Atom(name: 'ProfileStoreBase.currentUserId', context: context);

  @override
  String? get currentUserId {
    _$currentUserIdAtom.reportRead();
    return super.currentUserId;
  }

  @override
  set currentUserId(String? value) {
    _$currentUserIdAtom.reportWrite(value, super.currentUserId, () {
      super.currentUserId = value;
    });
  }

  late final _$loadProfilesAsyncAction =
      AsyncAction('ProfileStoreBase.loadProfiles', context: context);

  @override
  Future<void> loadProfiles() {
    return _$loadProfilesAsyncAction.run(() => super.loadProfiles());
  }

  late final _$_checkAdminStatusAsyncAction =
      AsyncAction('ProfileStoreBase._checkAdminStatus', context: context);

  @override
  Future<void> _checkAdminStatus() {
    return _$_checkAdminStatusAsyncAction.run(() => super._checkAdminStatus());
  }

  late final _$_loadCurrentUserAsyncAction =
      AsyncAction('ProfileStoreBase._loadCurrentUser', context: context);

  @override
  Future<void> _loadCurrentUser() {
    return _$_loadCurrentUserAsyncAction.run(() => super._loadCurrentUser());
  }

  late final _$loadProfileByIdAsyncAction =
      AsyncAction('ProfileStoreBase.loadProfileById', context: context);

  @override
  Future<void> loadProfileById(String id) {
    return _$loadProfileByIdAsyncAction.run(() => super.loadProfileById(id));
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('ProfileStoreBase.updateProfile', context: context);

  @override
  Future<bool> updateProfile(Profile profile) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(profile));
  }

  late final _$deleteProfileAsyncAction =
      AsyncAction('ProfileStoreBase.deleteProfile', context: context);

  @override
  Future<bool> deleteProfile(String id) {
    return _$deleteProfileAsyncAction.run(() => super.deleteProfile(id));
  }

  late final _$ProfileStoreBaseActionController =
      ActionController(name: 'ProfileStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$ProfileStoreBaseActionController.startAction(
        name: 'ProfileStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedProfile(Profile? profile) {
    final _$actionInfo = _$ProfileStoreBaseActionController.startAction(
        name: 'ProfileStoreBase.setSelectedProfile');
    try {
      return super.setSelectedProfile(profile);
    } finally {
      _$ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profiles: ${profiles},
isLoading: ${isLoading},
isAdmin: ${isAdmin},
errorMessage: ${errorMessage},
selectedProfile: ${selectedProfile},
currentUserProfile: ${currentUserProfile},
currentUserId: ${currentUserId},
hasProfiles: ${hasProfiles},
hasError: ${hasError}
    ''';
  }
}
