import 'package:conexaoolivia/core/repositories/event_repository.dart';
import 'package:conexaoolivia/modules/auth/stores/auth_store.dart';
import 'package:conexaoolivia/modules/eventos/events_module.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_store.dart';
import 'package:conexaoolivia/modules/galeria-eventos/gallery_module.dart';
import 'package:conexaoolivia/modules/parceiras/partners_module.dart';
import 'package:conexaoolivia/modules/quem-somos/quem_somos.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';
import 'modules/splash/pages/splash_page.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Repository
    i.addLazySingleton<IEventRepository>(() =>  EventRepository(Supabase.instance.client));

    // Registra o AuthStore como singleton
    i.addSingleton<AuthStore>(AuthStore.new);
    i.addSingleton<EventStore>(() => EventStore(i.get<IEventRepository>()));

  }
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
    r.module('/events', module: EventsModule());
    r.module('/gallery', module: GalleryModule());
    r.module('/partners', module: PartnersModule());
    r.module('/quem-somos', module: QuemSomosModule());
  }
}