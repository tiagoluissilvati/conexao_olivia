// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventFormStore on EventFormStoreBase, Store {
  Computed<bool>? _$isEditingComputed;

  @override
  bool get isEditing =>
      (_$isEditingComputed ??= Computed<bool>(() => super.isEditing,
              name: 'EventFormStoreBase.isEditing'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'EventFormStoreBase.isFormValid'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'EventFormStoreBase.hasError'))
          .value;

  late final _$titleAtom =
      Atom(name: 'EventFormStoreBase.title', context: context);

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: 'EventFormStoreBase.description', context: context);

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

  late final _$eventTimeAtom =
      Atom(name: 'EventFormStoreBase.eventTime', context: context);

  @override
  String get eventTime {
    _$eventTimeAtom.reportRead();
    return super.eventTime;
  }

  @override
  set eventTime(String value) {
    _$eventTimeAtom.reportWrite(value, super.eventTime, () {
      super.eventTime = value;
    });
  }

  late final _$locationAtom =
      Atom(name: 'EventFormStoreBase.location', context: context);

  @override
  String get location {
    _$locationAtom.reportRead();
    return super.location;
  }

  @override
  set location(String value) {
    _$locationAtom.reportWrite(value, super.location, () {
      super.location = value;
    });
  }

  late final _$selectedDateAtom =
      Atom(name: 'EventFormStoreBase.selectedDate', context: context);

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'EventFormStoreBase.isLoading', context: context);

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
      Atom(name: 'EventFormStoreBase.errorMessage', context: context);

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

  late final _$editingEventAtom =
      Atom(name: 'EventFormStoreBase.editingEvent', context: context);

  @override
  Event? get editingEvent {
    _$editingEventAtom.reportRead();
    return super.editingEvent;
  }

  @override
  set editingEvent(Event? value) {
    _$editingEventAtom.reportWrite(value, super.editingEvent, () {
      super.editingEvent = value;
    });
  }

  late final _$EventFormStoreBaseActionController =
      ActionController(name: 'EventFormStoreBase', context: context);

  @override
  void setTitle(String value) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEventTime(String value) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setEventTime');
    try {
      return super.setEventTime(value);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLocation(String value) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setLocation');
    try {
      return super.setLocation(value);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setSelectedDate');
    try {
      return super.setSelectedDate(date);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setError');
    try {
      return super.setError(error);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initializeWithEvent(Event event) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.initializeWithEvent');
    try {
      return super.initializeWithEvent(event);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearForm() {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.clearForm');
    try {
      return super.clearForm();
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Event buildEvent() {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.buildEvent');
    try {
      return super.buildEvent();
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
description: ${description},
eventTime: ${eventTime},
location: ${location},
selectedDate: ${selectedDate},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
editingEvent: ${editingEvent},
isEditing: ${isEditing},
isFormValid: ${isFormValid},
hasError: ${hasError}
    ''';
  }
}
