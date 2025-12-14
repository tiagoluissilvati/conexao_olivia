import 'package:conexaoolivia/core/repositories/profile_repository.dart';
import 'package:conexaoolivia/modules/profiles/pages/profile_form_store.dart';
import 'package:conexaoolivia/modules/profiles/pages/profile_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addLazySingleton<IProfileRepository>(() =>ProfileRepository(Supabase.instance.client));

    i.addSingleton<ProfileStore>(
          () => ProfileStore(i.get<IProfileRepository>()),
    );
    i.addSingleton<ProfileFormStore>(
          () => ProfileFormStore(),
    );

  }
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}