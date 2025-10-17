// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GalleryStore on GalleryStoreBase, Store {
  Computed<bool>? _$hasEventsComputed;

  @override
  bool get hasEvents =>
      (_$hasEventsComputed ??= Computed<bool>(() => super.hasEvents,
              name: 'GalleryStoreBase.hasEvents'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'GalleryStoreBase.hasError'))
          .value;

  late final _$galleryEventsAtom =
      Atom(name: 'GalleryStoreBase.galleryEvents', context: context);

  @override
  ObservableList<GalleryEvent> get galleryEvents {
    _$galleryEventsAtom.reportRead();
    return super.galleryEvents;
  }

  @override
  set galleryEvents(ObservableList<GalleryEvent> value) {
    _$galleryEventsAtom.reportWrite(value, super.galleryEvents, () {
      super.galleryEvents = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'GalleryStoreBase.isLoading', context: context);

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
      Atom(name: 'GalleryStoreBase.isAdmin', context: context);

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
      Atom(name: 'GalleryStoreBase.errorMessage', context: context);

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

  late final _$selectedEventAtom =
      Atom(name: 'GalleryStoreBase.selectedEvent', context: context);

  @override
  GalleryEvent? get selectedEvent {
    _$selectedEventAtom.reportRead();
    return super.selectedEvent;
  }

  @override
  set selectedEvent(GalleryEvent? value) {
    _$selectedEventAtom.reportWrite(value, super.selectedEvent, () {
      super.selectedEvent = value;
    });
  }

  late final _$isUploadingImagesAtom =
      Atom(name: 'GalleryStoreBase.isUploadingImages', context: context);

  @override
  bool get isUploadingImages {
    _$isUploadingImagesAtom.reportRead();
    return super.isUploadingImages;
  }

  @override
  set isUploadingImages(bool value) {
    _$isUploadingImagesAtom.reportWrite(value, super.isUploadingImages, () {
      super.isUploadingImages = value;
    });
  }

  late final _$uploadProgressAtom =
      Atom(name: 'GalleryStoreBase.uploadProgress', context: context);

  @override
  double get uploadProgress {
    _$uploadProgressAtom.reportRead();
    return super.uploadProgress;
  }

  @override
  set uploadProgress(double value) {
    _$uploadProgressAtom.reportWrite(value, super.uploadProgress, () {
      super.uploadProgress = value;
    });
  }

  late final _$loadGalleryEventsAsyncAction =
      AsyncAction('GalleryStoreBase.loadGalleryEvents', context: context);

  @override
  Future<void> loadGalleryEvents() {
    return _$loadGalleryEventsAsyncAction.run(() => super.loadGalleryEvents());
  }

  late final _$_checkAdminStatusAsyncAction =
      AsyncAction('GalleryStoreBase._checkAdminStatus', context: context);

  @override
  Future<void> _checkAdminStatus() {
    return _$_checkAdminStatusAsyncAction.run(() => super._checkAdminStatus());
  }

  late final _$loadGalleryEventByIdAsyncAction =
      AsyncAction('GalleryStoreBase.loadGalleryEventById', context: context);

  @override
  Future<void> loadGalleryEventById(String id) {
    return _$loadGalleryEventByIdAsyncAction
        .run(() => super.loadGalleryEventById(id));
  }

  late final _$createGalleryEventAsyncAction =
      AsyncAction('GalleryStoreBase.createGalleryEvent', context: context);

  @override
  Future<bool> createGalleryEvent(GalleryEvent event) {
    return _$createGalleryEventAsyncAction
        .run(() => super.createGalleryEvent(event));
  }

  late final _$updateGalleryEventAsyncAction =
      AsyncAction('GalleryStoreBase.updateGalleryEvent', context: context);

  @override
  Future<bool> updateGalleryEvent(GalleryEvent event) {
    return _$updateGalleryEventAsyncAction
        .run(() => super.updateGalleryEvent(event));
  }

  late final _$deleteGalleryEventAsyncAction =
      AsyncAction('GalleryStoreBase.deleteGalleryEvent', context: context);

  @override
  Future<bool> deleteGalleryEvent(String id) {
    return _$deleteGalleryEventAsyncAction
        .run(() => super.deleteGalleryEvent(id));
  }

  late final _$uploadImagesAsyncAction =
      AsyncAction('GalleryStoreBase.uploadImages', context: context);

  @override
  Future<bool> uploadImages(String eventId, List<ImageUpload> images) {
    return _$uploadImagesAsyncAction
        .run(() => super.uploadImages(eventId, images));
  }

  late final _$deleteImageAsyncAction =
      AsyncAction('GalleryStoreBase.deleteImage', context: context);

  @override
  Future<bool> deleteImage(String imageId) {
    return _$deleteImageAsyncAction.run(() => super.deleteImage(imageId));
  }

  late final _$deleteMultipleImagesAsyncAction =
      AsyncAction('GalleryStoreBase.deleteMultipleImages', context: context);

  @override
  Future<bool> deleteMultipleImages(List<String> imageIds) {
    return _$deleteMultipleImagesAsyncAction
        .run(() => super.deleteMultipleImages(imageIds));
  }

  late final _$updateImageOrderAsyncAction =
      AsyncAction('GalleryStoreBase.updateImageOrder', context: context);

  @override
  Future<bool> updateImageOrder(String imageId, int newOrder) {
    return _$updateImageOrderAsyncAction
        .run(() => super.updateImageOrder(imageId, newOrder));
  }

  late final _$setImageAsThumbnailAsyncAction =
      AsyncAction('GalleryStoreBase.setImageAsThumbnail', context: context);

  @override
  Future<bool> setImageAsThumbnail(String imageId) {
    return _$setImageAsThumbnailAsyncAction
        .run(() => super.setImageAsThumbnail(imageId));
  }

  late final _$processImageChangesAsyncAction =
      AsyncAction('GalleryStoreBase.processImageChanges', context: context);

  @override
  Future<bool> processImageChanges(String eventId, List<ImageUpload> newImages,
      List<String> imagesToRemove) {
    return _$processImageChangesAsyncAction.run(
        () => super.processImageChanges(eventId, newImages, imagesToRemove));
  }

  late final _$GalleryStoreBaseActionController =
      ActionController(name: 'GalleryStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$GalleryStoreBaseActionController.startAction(
        name: 'GalleryStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$GalleryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEvent(GalleryEvent? event) {
    final _$actionInfo = _$GalleryStoreBaseActionController.startAction(
        name: 'GalleryStoreBase.setSelectedEvent');
    try {
      return super.setSelectedEvent(event);
    } finally {
      _$GalleryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUploadProgress(double progress) {
    final _$actionInfo = _$GalleryStoreBaseActionController.startAction(
        name: 'GalleryStoreBase.setUploadProgress');
    try {
      return super.setUploadProgress(progress);
    } finally {
      _$GalleryStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
galleryEvents: ${galleryEvents},
isLoading: ${isLoading},
isAdmin: ${isAdmin},
errorMessage: ${errorMessage},
selectedEvent: ${selectedEvent},
isUploadingImages: ${isUploadingImages},
uploadProgress: ${uploadProgress},
hasEvents: ${hasEvents},
hasError: ${hasError}
    ''';
  }
}
