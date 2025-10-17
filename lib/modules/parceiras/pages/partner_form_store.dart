// modules/parceiras/pages/partner_form_store.dart
import 'package:mobx/mobx.dart';
import '../../galeria-eventos/models/image_upload_model.dart';
import '../models/partner_model.dart';

part 'partner_form_store.g.dart';

class PartnerFormStore = PartnerFormStoreBase with _$PartnerFormStore;

abstract class PartnerFormStoreBase with Store {
  @observable
  String name = '';

  @observable
  String description = '';

  @observable
  String address = '';

  @observable
  bool isActive = true;

  @observable
  ImageUpload? logo;

  @observable
  String? existingLogoUrl;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  Partner? editingPartner;

  @computed
  bool get isEditing => editingPartner != null;

  @computed
  bool get isFormValid => name.trim().isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasLogo => logo != null || (existingLogoUrl != null && existingLogoUrl!.isNotEmpty);

  @action
  void setName(String value) {
    name = value;
    _clearError();
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setAddress(String value) {
    address = value;
  }

  @action
  void setIsActive(bool value) {
    isActive = value;
  }

  @action
  void setLogo(ImageUpload? image) {
    logo = image;
  }

  @action
  void removeLogo() {
    logo = null;
    existingLogoUrl = null;
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
  void _clearError() {
    errorMessage = null;
  }

  @action
  void initializeWithPartner(Partner partner) {
    editingPartner = partner;
    name = partner.name;
    description = partner.description ?? '';
    address = partner.address ?? '';
    isActive = partner.isActive;
    existingLogoUrl = partner.logoUrl;
    logo = null;
    errorMessage = null;
  }

  @action
  void clearForm() {
    editingPartner = null;
    name = '';
    description = '';
    address = '';
    isActive = true;
    logo = null;
    existingLogoUrl = null;
    isLoading = false;
    errorMessage = null;
  }

  @action
  Partner buildPartner() {
    if (!isFormValid) {
      throw Exception('Formulário inválido');
    }

    final now = DateTime.now();

    if (isEditing) {
      return editingPartner!.copyWith(
        name: name.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        address: address.trim().isEmpty ? null : address.trim(),
        isActive: isActive,
        updatedAt: now,
        logoUrl: logo != null ? null : existingLogoUrl,
      );
    } else {
      // Para criação, não enviar o id
      return Partner(
        id: '', // Será ignorado no toJson()
        name: name.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        address: address.trim().isEmpty ? null : address.trim(),
        isActive: isActive,
        createdAt: now,
        updatedAt: now,
        createdBy: null, // Será preenchido no repository
        logoUrl: null,
      );
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    return null;
  }

  @computed
  bool get hasPendingChanges {
    return logo != null;
  }
}