// stores/event_store.dart
import 'package:conexaoolivia/core/repositories/event_repository.dart';
import 'package:conexaoolivia/modules/eventos/models/event_model.dart';
import 'package:conexaoolivia/modules/galeria-eventos/models/image_upload_model.dart';
import 'package:mobx/mobx.dart';

part 'event_store.g.dart';

class EventStore = EventStoreBase with _$EventStore;

abstract class EventStoreBase with Store {
  final IEventRepository _repository;

  EventStoreBase(this._repository);

  @observable
  ObservableList<Event> events = ObservableList<Event>();

  @observable
  bool isLoading = false;

  @observable
  bool isAdmin = false;

  @observable
  String? errorMessage;

  @observable
  Event? selectedEvent;

  @observable
  bool isUploadingBanners = false;

  @computed
  bool get hasEvents => events.isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  Event? get featuredEvent {
    try {
      return events.firstWhere((event) => event.isFeatured);
    } catch (e) {
      return null;
    }
  }

  @action
  Future<void> loadEvents() async {
    isLoading = true;
    errorMessage = null;

    try {
      await _checkAdminStatus();
      final eventsList = isAdmin
          ? await _repository.getAllEvents()
          : await _repository.getFutureEvents();

      events.clear();
      events.addAll(eventsList);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _checkAdminStatus() async {
    try {
      isAdmin = await _repository.isUserAdmin();
    } catch (e) {
      isAdmin = false;
    }
  }

  @action
  Future<void> loadEventById(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      selectedEvent = await _repository.getEventById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> createEvent(
      Event event, {
        ImageUpload? bannerCarousel,
        ImageUpload? bannerLarge,
      }) async {
    isLoading = true;
    errorMessage = null;

    try {
      // Se marcado como destaque, desmarcar outros
      if (event.isFeatured) {
        await _repository.clearFeaturedEvents();
      }

      final newEvent = await _repository.createEvent(event);

      // Upload dos banners se existirem
      Event finalEvent = newEvent;
      if (bannerCarousel != null || bannerLarge != null) {
        isUploadingBanners = true;
        finalEvent = await _repository.uploadEventBanners(
          newEvent.id,
          bannerCarousel: bannerCarousel,
          bannerLarge: bannerLarge,
        );
        isUploadingBanners = false;
      }

      events.add(finalEvent);
      _sortEvents();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      isUploadingBanners = false;
    }
  }

  @action
  Future<bool> updateEvent(
      Event event, {
        ImageUpload? bannerCarousel,
        ImageUpload? bannerLarge,
      }) async {
    isLoading = true;
    errorMessage = null;

    try {
      // Se marcado como destaque, desmarcar outros
      if (event.isFeatured) {
        await _repository.clearFeaturedEvents(exceptId: event.id);
      }

      var updatedEvent = await _repository.updateEvent(event);

      // Upload dos novos banners se existirem
      if (bannerCarousel != null || bannerLarge != null) {
        isUploadingBanners = true;
        updatedEvent = await _repository.uploadEventBanners(
          updatedEvent.id,
          bannerCarousel: bannerCarousel,
          bannerLarge: bannerLarge,
        );
        isUploadingBanners = false;
      }

      final index = events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        events[index] = updatedEvent;
        _sortEvents();
      }
      selectedEvent = updatedEvent;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      isUploadingBanners = false;
    }
  }

  @action
  Future<bool> deleteEvent(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _repository.deleteEvent(id);
      events.removeWhere((event) => event.id == id);
      if (selectedEvent?.id == id) {
        selectedEvent = null;
      }
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteBanner(String eventId, BannerType bannerType) async {
    errorMessage = null;

    try {
      await _repository.deleteBanner(eventId, bannerType);

      // Atualizar localmente
      final index = events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        final event = events[index];
        events[index] = bannerType == BannerType.carousel
            ? event.copyWith(bannerCarouselUrl: '')
            : event.copyWith(bannerLargeUrl: '');
      }

      if (selectedEvent?.id == eventId) {
        selectedEvent = bannerType == BannerType.carousel
            ? selectedEvent!.copyWith(bannerCarouselUrl: '')
            : selectedEvent!.copyWith(bannerLargeUrl: '');
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setSelectedEvent(Event? event) {
    selectedEvent = event;
  }

  void _sortEvents() {
    events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
  }

  void dispose() {
    // Cleanup se necessário
  }
}

enum BannerType { carousel, large }