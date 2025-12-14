// modules/profiles/profiles_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/repositories/profile_repository.dart';
import 'pages/profile_store.dart';
import 'pages/profile_form_store.dart';
import 'pages/profiles_list_page.dart';
import 'pages/profile_detail_page.dart';
import 'pages/profile_form_page.dart';

class ProfilesModule extends Module {
  @override
  void binds(i) {
    // Repository
    i.addLazySingleton<IProfileRepository>(
          () => ProfileRepository(Supabase.instance.client),
    );

    // Stores
    i.addSingleton<ProfileStore>(
          () => ProfileStore(i.get<IProfileRepository>()),
    );
    i.addSingleton<ProfileFormStore>(
          () => ProfileFormStore(),
    );
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const ProfilesListPage());
    r.child('/detail', child: (context) => const ProfileDetailPage());
    r.child('/form', child: (context) => const ProfileFormPage());
  }
}