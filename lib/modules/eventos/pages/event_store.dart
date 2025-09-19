// stores/event_store.dart
import 'package:conexaoolivia/core/repositories/event_repository.dart';
import 'package:conexaoolivia/modules/eventos/models/event_model.dart';

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

  @computed
  bool get hasEvents => events.isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

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
  Future<bool> createEvent(Event event) async {
    isLoading = true;
    errorMessage = null;

    try {
      final newEvent = await _repository.createEvent(event);
      events.add(newEvent);
      _sortEvents();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateEvent(Event event) async {
    isLoading = true;
    errorMessage = null;

    try {
      final updatedEvent = await _repository.updateEvent(event);
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