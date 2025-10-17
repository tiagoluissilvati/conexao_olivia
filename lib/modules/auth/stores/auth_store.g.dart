// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  late final _$currentUserAtom =
      Atom(name: '_AuthStoreBase.currentUser', context: context);

  @override
  UserModel? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(UserModel? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AuthStoreBase.isLoading', context: context);

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
      Atom(name: '_AuthStoreBase.errorMessage', context: context);

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

  late final _$isAuthenticatedAtom =
      Atom(name: '_AuthStoreBase.isAuthenticated', context: context);

  @override
  bool get isAuthenticated {
    _$isAuthenticatedAtom.reportRead();
    return super.isAuthenticated;
  }

  @override
  set isAuthenticated(bool value) {
    _$isAuthenticatedAtom.reportWrite(value, super.isAuthenticated, () {
      super.isAuthenticated = value;
    });
  }

  late final _$signInAsyncAction =
      AsyncAction('_AuthStoreBase.signIn', context: context);

  @override
  Future<bool> signIn({required String email, required String password}) {
    return _$signInAsyncAction
        .run(() => super.signIn(email: email, password: password));
  }

  late final _$signUpAsyncAction =
      AsyncAction('_AuthStoreBase.signUp', context: context);

  @override
  Future<bool> signUp(
      {required String email,
      required String password,
      required String name,
      required String cpf,
      String? phone}) {
    return _$signUpAsyncAction.run(() => super.signUp(
        email: email, password: password, name: name, cpf: cpf, phone: phone));
  }

  late final _$signOutAsyncAction =
      AsyncAction('_AuthStoreBase.signOut', context: context);

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$resetPasswordAsyncAction =
      AsyncAction('_AuthStoreBase.resetPassword', context: context);

  @override
  Future<bool> resetPassword(String email) {
    return _$resetPasswordAsyncAction.run(() => super.resetPassword(email));
  }

  late final _$checkAuthStateAsyncAction =
      AsyncAction('_AuthStoreBase.checkAuthState', context: context);

  @override
  Future<void> checkAuthState() {
    return _$checkAuthStateAsyncAction.run(() => super.checkAuthState());
  }

  late final _$changePasswordAsyncAction =
      AsyncAction('_AuthStoreBase.changePassword', context: context);

  @override
  Future<bool> changePassword(
      {required String currentPassword, required String newPassword}) {
    return _$changePasswordAsyncAction.run(() => super.changePassword(
        currentPassword: currentPassword, newPassword: newPassword));
  }

  late final _$_AuthStoreBaseActionController =
      ActionController(name: '_AuthStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
