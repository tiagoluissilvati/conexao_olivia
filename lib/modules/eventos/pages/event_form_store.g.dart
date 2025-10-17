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
  Computed<bool>? _$hasBannerCarouselComputed;

  @override
  bool get hasBannerCarousel => (_$hasBannerCarouselComputed ??= Computed<bool>(
          () => super.hasBannerCarousel,
          name: 'EventFormStoreBase.hasBannerCarousel'))
      .value;
  Computed<bool>? _$hasBannerLargeComputed;

  @override
  bool get hasBannerLarge =>
      (_$hasBannerLargeComputed ??= Computed<bool>(() => super.hasBannerLarge,
              name: 'EventFormStoreBase.hasBannerLarge'))
          .value;
  Computed<bool>? _$hasPendingChangesComputed;

  @override
  bool get hasPendingChanges => (_$hasPendingChangesComputed ??= Computed<bool>(
          () => super.hasPendingChanges,
          name: 'EventFormStoreBase.hasPendingChanges'))
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

  late final _$linkAtom =
      Atom(name: 'EventFormStoreBase.link', context: context);

  @override
  String get link {
    _$linkAtom.reportRead();
    return super.link;
  }

  @override
  set link(String value) {
    _$linkAtom.reportWrite(value, super.link, () {
      super.link = value;
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

  late final _$isFeaturedAtom =
      Atom(name: 'EventFormStoreBase.isFeatured', context: context);

  @override
  bool get isFeatured {
    _$isFeaturedAtom.reportRead();
    return super.isFeatured;
  }

  @override
  set isFeatured(bool value) {
    _$isFeaturedAtom.reportWrite(value, super.isFeatured, () {
      super.isFeatured = value;
    });
  }

  late final _$bannerCarouselAtom =
      Atom(name: 'EventFormStoreBase.bannerCarousel', context: context);

  @override
  ImageUpload? get bannerCarousel {
    _$bannerCarouselAtom.reportRead();
    return super.bannerCarousel;
  }

  @override
  set bannerCarousel(ImageUpload? value) {
    _$bannerCarouselAtom.reportWrite(value, super.bannerCarousel, () {
      super.bannerCarousel = value;
    });
  }

  late final _$bannerLargeAtom =
      Atom(name: 'EventFormStoreBase.bannerLarge', context: context);

  @override
  ImageUpload? get bannerLarge {
    _$bannerLargeAtom.reportRead();
    return super.bannerLarge;
  }

  @override
  set bannerLarge(ImageUpload? value) {
    _$bannerLargeAtom.reportWrite(value, super.bannerLarge, () {
      super.bannerLarge = value;
    });
  }

  late final _$existingBannerCarouselUrlAtom = Atom(
      name: 'EventFormStoreBase.existingBannerCarouselUrl', context: context);

  @override
  String? get existingBannerCarouselUrl {
    _$existingBannerCarouselUrlAtom.reportRead();
    return super.existingBannerCarouselUrl;
  }

  @override
  set existingBannerCarouselUrl(String? value) {
    _$existingBannerCarouselUrlAtom
        .reportWrite(value, super.existingBannerCarouselUrl, () {
      super.existingBannerCarouselUrl = value;
    });
  }

  late final _$existingBannerLargeUrlAtom =
      Atom(name: 'EventFormStoreBase.existingBannerLargeUrl', context: context);

  @override
  String? get existingBannerLargeUrl {
    _$existingBannerLargeUrlAtom.reportRead();
    return super.existingBannerLargeUrl;
  }

  @override
  set existingBannerLargeUrl(String? value) {
    _$existingBannerLargeUrlAtom
        .reportWrite(value, super.existingBannerLargeUrl, () {
      super.existingBannerLargeUrl = value;
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
  void setLink(String value) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setLink');
    try {
      return super.setLink(value);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsFeatured(bool value) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setIsFeatured');
    try {
      return super.setIsFeatured(value);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBannerCarousel(ImageUpload? image) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setBannerCarousel');
    try {
      return super.setBannerCarousel(image);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBannerLarge(ImageUpload? image) {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.setBannerLarge');
    try {
      return super.setBannerLarge(image);
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBannerCarousel() {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.removeBannerCarousel');
    try {
      return super.removeBannerCarousel();
    } finally {
      _$EventFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBannerLarge() {
    final _$actionInfo = _$EventFormStoreBaseActionController.startAction(
        name: 'EventFormStoreBase.removeBannerLarge');
    try {
      return super.removeBannerLarge();
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
link: ${link},
selectedDate: ${selectedDate},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
editingEvent: ${editingEvent},
isFeatured: ${isFeatured},
bannerCarousel: ${bannerCarousel},
bannerLarge: ${bannerLarge},
existingBannerCarouselUrl: ${existingBannerCarouselUrl},
existingBannerLargeUrl: ${existingBannerLargeUrl},
isEditing: ${isEditing},
isFormValid: ${isFormValid},
hasError: ${hasError},
hasBannerCarousel: ${hasBannerCarousel},
hasBannerLarge: ${hasBannerLarge},
hasPendingChanges: ${hasPendingChanges}
    ''';
  }
}
