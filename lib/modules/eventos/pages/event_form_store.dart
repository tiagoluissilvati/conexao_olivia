// stores/event_form_store.dart
import 'package:mobx/mobx.dart';
import '../models/event_model.dart';

part 'event_form_store.g.dart';

class EventFormStore = EventFormStoreBase with _$EventFormStore;

abstract class EventFormStoreBase with Store {

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  String eventTime = '';

  @observable
  String location = '';

  @observable
  String link = '';

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  Event? editingEvent;

  @computed
  bool get isEditing => editingEvent != null;

  @computed
  bool get isFormValid => title.trim().isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @action
  void setTitle(String value) {
    title = value;
    _clearError();
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setEventTime(String value) {
    eventTime = value;
  }

  @action
  void setLocation(String value) {
    location = value;
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void setLink(String value) {
    link = value;
  }
  @action
  void _clearError() {
    errorMessage = null;
  }

  @action
  void initializeWithEvent(Event event) {
    editingEvent = event;
    title = event.title;
    description = event.description ?? '';
    eventTime = event.eventTime ?? '';
    location = event.location ?? '';
    selectedDate = event.eventDate;
    link = event.linkCheckout ?? '';
    errorMessage = null;
  }

  @action
  void clearForm() {
    editingEvent = null;
    title = '';
    description = '';
    eventTime = '';
    location = '';
    link = '';
    selectedDate = DateTime.now();
    isLoading = false;
    errorMessage = null;
  }

  @action
  Event buildEvent() {
    if (!isFormValid) {
      throw Exception('Formulário inválido');
    }

    final now = DateTime.now();

    if (isEditing) {
      // Para edição, manter o ID existente e outros campos
      return editingEvent!.copyWith(
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        eventDate: selectedDate,
        eventTime: eventTime.trim().isEmpty ? null : eventTime.trim(),
        location: location.trim().isEmpty ? null : location.trim(),
        updatedAt: now,
      );
    } else {
      // Para criação, criar evento sem ID (será gerado pelo Supabase)
      return Event(
        id: '', // ID vazio - será ignorado no toJson()
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        eventDate: selectedDate,
        eventTime: eventTime.trim().isEmpty ? null : eventTime.trim(),
        location: location.trim().isEmpty ? null : location.trim(),
        createdBy: null, // Será preenchido automaticamente pelo Supabase
        createdAt: now,
        updatedAt: now,
        linkCheckout: link.trim().isEmpty ? null : link.trim()
      );
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Título é obrigatório';
    }
    return null;
  }
}