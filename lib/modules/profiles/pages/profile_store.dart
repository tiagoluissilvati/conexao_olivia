import 'package:mobx/mobx.dart';
import '../../../core/repositories/profile_repository.dart';
import '../models/profile_model.dart';

part 'profile_store.g.dart';

class ProfileStore = ProfileStoreBase with _$ProfileStore;

abstract class ProfileStoreBase with Store {
  final IProfileRepository _repository;

  ProfileStoreBase(this._repository);

  @observable
  ObservableList<Profile> profiles = ObservableList<Profile>();

  @observable
  bool isLoading = false;

  @observable
  bool isAdmin = false;

  @observable
  String? errorMessage;

  @observable
  Profile? selectedProfile;

  @observable
  Profile? currentUserProfile;

  @observable
  String? currentUserId;

  @computed
  bool get hasProfiles => profiles.isNotEmpty;

  @computed
  bool get hasError => errorMessage != null;

  @action
  Future<void> loadProfiles() async {
    isLoading = true;
    errorMessage = null;

    try {
      await _checkAdminStatus();
      await _loadCurrentUser();

      final profilesList = await _repository.getAllProfiles();

      profiles.clear();
      profiles.addAll(profilesList);
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
  Future<void> _loadCurrentUser() async {
    try {
      currentUserId = await _repository.getCurrentUserId();
      if (currentUserId != null) {
        currentUserProfile = await _repository.getCurrentUserProfile();
      }
    } catch (e) {
      currentUserId = null;
      currentUserProfile = null;
    }
  }

  @action
  Future<void> loadProfileById(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      selectedProfile = await _repository.getProfileById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
  @action
  Future<bool> updateProfile(Profile profile) async {
    isLoading = true;
    errorMessage = null;

    try {
      // 🔍 DEBUG: Verificar o que está chegando na Store
      print('🔍 DEBUG Store - Profile recebido:');
      print('   ID: ${profile.id}');
      print('   Name: ${profile.name}');
      print('   Email: ${profile.email}');
      print('   JSON completo: ${profile.toJson()}');

      final updatedProfile = await _repository.updateProfile(profile);

      final index = profiles.indexWhere((p) => p.id == profile.id);
      if (index != -1) {
        profiles[index] = updatedProfile;
        _sortProfiles();
      }

      selectedProfile = updatedProfile;

      // Atualizar perfil atual se for o mesmo usuário
      if (updatedProfile.id == currentUserId) {
        currentUserProfile = updatedProfile;
      }

      print('✅ Perfil atualizado com sucesso!');
      return true;
    } catch (e) {
      print('❌ Erro na Store: $e');
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteProfile(String id) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _repository.deleteProfile(id);
      profiles.removeWhere((profile) => profile.id == id);

      if (selectedProfile?.id == id) {
        selectedProfile = null;
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
  void setSelectedProfile(Profile? profile) {
    selectedProfile = profile;
  }

  void _sortProfiles() {
    profiles.sort((a, b) {
      final nameA = a.name ?? a.email;
      final nameB = b.name ?? b.email;
      return nameA.compareTo(nameB);
    });
  }

  bool isCurrentUser(String profileId) {
    return currentUserId == profileId;
  }

  void dispose() {
    // Cleanup se necessário
  }
}