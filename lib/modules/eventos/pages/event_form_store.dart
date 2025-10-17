// stores/event_form_store.dart
import 'package:mobx/mobx.dart';
import '../../galeria-eventos/models/image_upload_model.dart';
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

  // NOVOS CAMPOS
  @observable
  bool isFeatured = false;

  @observable
  ImageUpload? bannerCarousel;

  @observable
  ImageUpload? bannerLarge;

  // URLs dos banners existentes (para edição)
  @observable
  String? existingBannerCarouselUrl;

  @observable
  String? existingBannerLargeUrl;

  @computed
  bool get isEditing => editingEvent != null;

  @computed
  bool get isFormValid => title.trim().isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasBannerCarousel => bannerCarousel != null || (existingBannerCarouselUrl != null && existingBannerCarouselUrl!.isNotEmpty);

  @computed
  bool get hasBannerLarge => bannerLarge != null || (existingBannerLargeUrl != null && existingBannerLargeUrl!.isNotEmpty);

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
  void setIsFeatured(bool value) {
    isFeatured = value;
  }

  @action
  void setBannerCarousel(ImageUpload? image) {
    bannerCarousel = image;
  }

  @action
  void setBannerLarge(ImageUpload? image) {
    bannerLarge = image;
  }

  @action
  void removeBannerCarousel() {
    bannerCarousel = null;
    existingBannerCarouselUrl = null;
  }

  @action
  void removeBannerLarge() {
    bannerLarge = null;
    existingBannerLargeUrl = null;
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
    isFeatured = event.isFeatured;
    existingBannerCarouselUrl = event.bannerCarouselUrl;
    existingBannerLargeUrl = event.bannerLargeUrl;
    bannerCarousel = null;
    bannerLarge = null;
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
    isFeatured = false;
    bannerCarousel = null;
    bannerLarge = null;
    existingBannerCarouselUrl = null;
    existingBannerLargeUrl = null;
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
      return editingEvent!.copyWith(
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        eventDate: selectedDate,
        eventTime: eventTime.trim().isEmpty ? null : eventTime.trim(),
        location: location.trim().isEmpty ? null : location.trim(),
        linkCheckout: link.trim().isEmpty ? null : link.trim(),
        isFeatured: isFeatured,
        updatedAt: now,
        // Manter as URLs existentes se não houver novas imagens
        bannerCarouselUrl: bannerCarousel != null ? null : existingBannerCarouselUrl,
        bannerLargeUrl: bannerLarge != null ? null : existingBannerLargeUrl,
      );
    } else {
      return Event(
        id: '',
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        eventDate: selectedDate,
        eventTime: eventTime.trim().isEmpty ? null : eventTime.trim(),
        location: location.trim().isEmpty ? null : location.trim(),
        createdBy: null,
        createdAt: now,
        updatedAt: now,
        linkCheckout: link.trim().isEmpty ? null : link.trim(),
        isFeatured: isFeatured,
      );
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Título é obrigatório';
    }
    return null;
  }

  @computed
  bool get hasPendingChanges {
    return bannerCarousel != null || bannerLarge != null;
  }
}