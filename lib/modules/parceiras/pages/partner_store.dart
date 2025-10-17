// modules/parceiras/pages/partner_store.dart
import 'package:mobx/mobx.dart';
import '../../../core/repositories/partner_repository.dart';
import '../models/partner_model.dart';
import '../../galeria-eventos/models/image_upload_model.dart';

part 'partner_store.g.dart';

class PartnerStore = PartnerStoreBase with _$PartnerStore;

abstract class PartnerStoreBase with Store {
  final IPartnerRepository _repository;

  PartnerStoreBase(this._repository);

  @observable
  ObservableList<Partner> partners = ObservableList<Partner>();

  @observable
  bool isLoading = false;

  @observable
  bool isAdmin = false;

  @observable
  String? errorMessage;

  @observable
  Partner? selectedPartner;

  @observable
  bool isUploadingLogo = false;

  @computed
  bool get hasPartners => partners.isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @action
  Future<void> loadPartners() async {
    isLoading = true;
    errorMessage = null;

    try {
      await _checkAdminStatus();
      final partnersList = isAdmin
          ? await _repository.getAllPartners()
          : await _repository.getActivePartners();

      partners.clear();
      partners.addAll(partnersList);
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
  Future<void> loadPartnerById(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      selectedPartner = await _repository.getPartnerById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> createPartner(Partner partner, {ImageUpload? logo}) async {
    isLoading = true;
    errorMessage = null;

    try {
      final newPartner = await _repository.createPartner(partner);

      // Upload do logo se existir
      Partner finalPartner = newPartner;
      if (logo != null) {
        isUploadingLogo = true;
        finalPartner = await _repository.uploadPartnerLogo(newPartner.id, logo);
        isUploadingLogo = false;
      }

      partners.add(finalPartner);
      _sortPartners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      isUploadingLogo = false;
    }
  }

  @action
  Future<bool> updatePartner(Partner partner, {ImageUpload? logo}) async {
    isLoading = true;
    errorMessage = null;

    try {
      var updatedPartner = await _repository.updatePartner(partner);

      // Upload do novo logo se existir
      if (logo != null) {
        isUploadingLogo = true;
        updatedPartner = await _repository.uploadPartnerLogo(updatedPartner.id, logo);
        isUploadingLogo = false;
      }

      final index = partners.indexWhere((p) => p.id == partner.id);
      if (index != -1) {
        partners[index] = updatedPartner;
        _sortPartners();
      }
      selectedPartner = updatedPartner;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      isUploadingLogo = false;
    }
  }

  @action
  Future<bool> deletePartner(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _repository.deletePartner(id);
      partners.removeWhere((partner) => partner.id == id);
      if (selectedPartner?.id == id) {
        selectedPartner = null;
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
  Future<bool> deleteLogo(String partnerId) async {
    errorMessage = null;

    try {
      await _repository.deleteLogo(partnerId);

      // Atualizar localmente
      final index = partners.indexWhere((p) => p.id == partnerId);
      if (index != -1) {
        final partner = partners[index];
        partners[index] = partner.copyWith(logoUrl: '');
      }

      if (selectedPartner?.id == partnerId) {
        selectedPartner = selectedPartner!.copyWith(logoUrl: '');
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
  void setSelectedPartner(Partner? partner) {
    selectedPartner = partner;
  }

  void _sortPartners() {
    partners.sort((a, b) => a.name.compareTo(b.name));
  }

  void dispose() {
    // Cleanup se necessário
  }
}