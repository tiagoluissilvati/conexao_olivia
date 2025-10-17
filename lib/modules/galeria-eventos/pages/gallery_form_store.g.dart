// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GalleryFormStore on GalleryFormStoreBase, Store {
  Computed<bool>? _$isEditingComputed;

  @override
  bool get isEditing =>
      (_$isEditingComputed ??= Computed<bool>(() => super.isEditing,
              name: 'GalleryFormStoreBase.isEditing'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: 'GalleryFormStoreBase.isFormValid'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'GalleryFormStoreBase.hasError'))
          .value;
  Computed<bool>? _$hasImagesComputed;

  @override
  bool get hasImages =>
      (_$hasImagesComputed ??= Computed<bool>(() => super.hasImages,
              name: 'GalleryFormStoreBase.hasImages'))
          .value;
  Computed<int>? _$totalImagesCountComputed;

  @override
  int get totalImagesCount => (_$totalImagesCountComputed ??= Computed<int>(
          () => super.totalImagesCount,
          name: 'GalleryFormStoreBase.totalImagesCount'))
      .value;
  Computed<double>? _$totalImageSizeComputed;

  @override
  double get totalImageSize =>
      (_$totalImageSizeComputed ??= Computed<double>(() => super.totalImageSize,
              name: 'GalleryFormStoreBase.totalImageSize'))
          .value;
  Computed<String>? _$totalImageSizeFormattedComputed;

  @override
  String get totalImageSizeFormatted => (_$totalImageSizeFormattedComputed ??=
          Computed<String>(() => super.totalImageSizeFormatted,
              name: 'GalleryFormStoreBase.totalImageSizeFormatted'))
      .value;
  Computed<bool>? _$hasPendingChangesComputed;

  @override
  bool get hasPendingChanges => (_$hasPendingChangesComputed ??= Computed<bool>(
          () => super.hasPendingChanges,
          name: 'GalleryFormStoreBase.hasPendingChanges'))
      .value;
  Computed<GalleryImage?>? _$currentThumbnailComputed;

  @override
  GalleryImage? get currentThumbnail => (_$currentThumbnailComputed ??=
          Computed<GalleryImage?>(() => super.currentThumbnail,
              name: 'GalleryFormStoreBase.currentThumbnail'))
      .value;

  late final _$titleAtom =
      Atom(name: 'GalleryFormStoreBase.title', context: context);

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
      Atom(name: 'GalleryFormStoreBase.description', context: context);

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

  late final _$selectedDateAtom =
      Atom(name: 'GalleryFormStoreBase.selectedDate', context: context);

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
      Atom(name: 'GalleryFormStoreBase.isLoading', context: context);

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
      Atom(name: 'GalleryFormStoreBase.errorMessage', context: context);

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
      Atom(name: 'GalleryFormStoreBase.editingEvent', context: context);

  @override
  GalleryEvent? get editingEvent {
    _$editingEventAtom.reportRead();
    return super.editingEvent;
  }

  @override
  set editingEvent(GalleryEvent? value) {
    _$editingEventAtom.reportWrite(value, super.editingEvent, () {
      super.editingEvent = value;
    });
  }

  late final _$selectedImagesAtom =
      Atom(name: 'GalleryFormStoreBase.selectedImages', context: context);

  @override
  ObservableList<ImageUpload> get selectedImages {
    _$selectedImagesAtom.reportRead();
    return super.selectedImages;
  }

  @override
  set selectedImages(ObservableList<ImageUpload> value) {
    _$selectedImagesAtom.reportWrite(value, super.selectedImages, () {
      super.selectedImages = value;
    });
  }

  late final _$existingImagesAtom =
      Atom(name: 'GalleryFormStoreBase.existingImages', context: context);

  @override
  ObservableList<GalleryImage> get existingImages {
    _$existingImagesAtom.reportRead();
    return super.existingImages;
  }

  @override
  set existingImages(ObservableList<GalleryImage> value) {
    _$existingImagesAtom.reportWrite(value, super.existingImages, () {
      super.existingImages = value;
    });
  }

  late final _$imagesToRemoveAtom =
      Atom(name: 'GalleryFormStoreBase.imagesToRemove', context: context);

  @override
  ObservableList<String> get imagesToRemove {
    _$imagesToRemoveAtom.reportRead();
    return super.imagesToRemove;
  }

  @override
  set imagesToRemove(ObservableList<String> value) {
    _$imagesToRemoveAtom.reportWrite(value, super.imagesToRemove, () {
      super.imagesToRemove = value;
    });
  }

  late final _$GalleryFormStoreBaseActionController =
      ActionController(name: 'GalleryFormStoreBase', context: context);

  @override
  void setTitle(String value) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.setSelectedDate');
    try {
      return super.setSelectedDate(date);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.setError');
    try {
      return super.setError(error);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addImages(List<ImageUpload> images) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.addImages');
    try {
      return super.addImages(images);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeImage(ImageUpload image) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.removeImage');
    try {
      return super.removeImage(image);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearImages() {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.clearImages');
    try {
      return super.clearImages();
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reorderImages(int oldIndex, int newIndex) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.reorderImages');
    try {
      return super.reorderImages(oldIndex, newIndex);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markImageForRemoval(String imageId) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.markImageForRemoval');
    try {
      return super.markImageForRemoval(imageId);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cancelImageRemoval(String imageId) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.cancelImageRemoval');
    try {
      return super.cancelImageRemoval(imageId);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImageAsThumbnail(String imageId) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.setImageAsThumbnail');
    try {
      return super.setImageAsThumbnail(imageId);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initializeWithEvent(GalleryEvent event) {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.initializeWithEvent');
    try {
      return super.initializeWithEvent(event);
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearForm() {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.clearForm');
    try {
      return super.clearForm();
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  GalleryEvent buildGalleryEvent() {
    final _$actionInfo = _$GalleryFormStoreBaseActionController.startAction(
        name: 'GalleryFormStoreBase.buildGalleryEvent');
    try {
      return super.buildGalleryEvent();
    } finally {
      _$GalleryFormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
description: ${description},
selectedDate: ${selectedDate},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
editingEvent: ${editingEvent},
selectedImages: ${selectedImages},
existingImages: ${existingImages},
imagesToRemove: ${imagesToRemove},
isEditing: ${isEditing},
isFormValid: ${isFormValid},
hasError: ${hasError},
hasImages: ${hasImages},
totalImagesCount: ${totalImagesCount},
totalImageSize: ${totalImageSize},
totalImageSizeFormatted: ${totalImageSizeFormatted},
hasPendingChanges: ${hasPendingChanges},
currentThumbnail: ${currentThumbnail}
    ''';
  }
}
