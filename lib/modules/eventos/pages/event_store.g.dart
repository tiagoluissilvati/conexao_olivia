// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventStore on EventStoreBase, Store {
  Computed<bool>? _$hasEventsComputed;

  @override
  bool get hasEvents =>
      (_$hasEventsComputed ??= Computed<bool>(() => super.hasEvents,
              name: 'EventStoreBase.hasEvents'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??=
          Computed<bool>(() => super.hasError, name: 'EventStoreBase.hasError'))
      .value;
  Computed<Event?>? _$featuredEventComputed;

  @override
  Event? get featuredEvent =>
      (_$featuredEventComputed ??= Computed<Event?>(() => super.featuredEvent,
              name: 'EventStoreBase.featuredEvent'))
          .value;

  late final _$eventsAtom =
      Atom(name: 'EventStoreBase.events', context: context);

  @override
  ObservableList<Event> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(ObservableList<Event> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'EventStoreBase.isLoading', context: context);

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
      Atom(name: 'EventStoreBase.isAdmin', context: context);

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
      Atom(name: 'EventStoreBase.errorMessage', context: context);

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
      Atom(name: 'EventStoreBase.selectedEvent', context: context);

  @override
  Event? get selectedEvent {
    _$selectedEventAtom.reportRead();
    return super.selectedEvent;
  }

  @override
  set selectedEvent(Event? value) {
    _$selectedEventAtom.reportWrite(value, super.selectedEvent, () {
      super.selectedEvent = value;
    });
  }

  late final _$isUploadingBannersAtom =
      Atom(name: 'EventStoreBase.isUploadingBanners', context: context);

  @override
  bool get isUploadingBanners {
    _$isUploadingBannersAtom.reportRead();
    return super.isUploadingBanners;
  }

  @override
  set isUploadingBanners(bool value) {
    _$isUploadingBannersAtom.reportWrite(value, super.isUploadingBanners, () {
      super.isUploadingBanners = value;
    });
  }

  late final _$loadEventsAsyncAction =
      AsyncAction('EventStoreBase.loadEvents', context: context);

  @override
  Future<void> loadEvents() {
    return _$loadEventsAsyncAction.run(() => super.loadEvents());
  }

  late final _$_checkAdminStatusAsyncAction =
      AsyncAction('EventStoreBase._checkAdminStatus', context: context);

  @override
  Future<void> _checkAdminStatus() {
    return _$_checkAdminStatusAsyncAction.run(() => super._checkAdminStatus());
  }

  late final _$loadEventByIdAsyncAction =
      AsyncAction('EventStoreBase.loadEventById', context: context);

  @override
  Future<void> loadEventById(String id) {
    return _$loadEventByIdAsyncAction.run(() => super.loadEventById(id));
  }

  late final _$createEventAsyncAction =
      AsyncAction('EventStoreBase.createEvent', context: context);

  @override
  Future<bool> createEvent(Event event,
      {ImageUpload? bannerCarousel, ImageUpload? bannerLarge}) {
    return _$createEventAsyncAction.run(() => super.createEvent(event,
        bannerCarousel: bannerCarousel, bannerLarge: bannerLarge));
  }

  late final _$updateEventAsyncAction =
      AsyncAction('EventStoreBase.updateEvent', context: context);

  @override
  Future<bool> updateEvent(Event event,
      {ImageUpload? bannerCarousel, ImageUpload? bannerLarge}) {
    return _$updateEventAsyncAction.run(() => super.updateEvent(event,
        bannerCarousel: bannerCarousel, bannerLarge: bannerLarge));
  }

  late final _$deleteEventAsyncAction =
      AsyncAction('EventStoreBase.deleteEvent', context: context);

  @override
  Future<bool> deleteEvent(String id) {
    return _$deleteEventAsyncAction.run(() => super.deleteEvent(id));
  }

  late final _$deleteBannerAsyncAction =
      AsyncAction('EventStoreBase.deleteBanner', context: context);

  @override
  Future<bool> deleteBanner(String eventId, BannerType bannerType) {
    return _$deleteBannerAsyncAction
        .run(() => super.deleteBanner(eventId, bannerType));
  }

  late final _$EventStoreBaseActionController =
      ActionController(name: 'EventStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$EventStoreBaseActionController.startAction(
        name: 'EventStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$EventStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEvent(Event? event) {
    final _$actionInfo = _$EventStoreBaseActionController.startAction(
        name: 'EventStoreBase.setSelectedEvent');
    try {
      return super.setSelectedEvent(event);
    } finally {
      _$EventStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
events: ${events},
isLoading: ${isLoading},
isAdmin: ${isAdmin},
errorMessage: ${errorMessage},
selectedEvent: ${selectedEvent},
isUploadingBanners: ${isUploadingBanners},
hasEvents: ${hasEvents},
hasError: ${hasError},
featuredEvent: ${featuredEvent}
    ''';
  }
}
