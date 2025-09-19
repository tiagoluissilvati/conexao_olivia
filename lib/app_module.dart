import 'package:conexaoolivia/modules/auth/stores/auth_store.dart';
import 'package:conexaoolivia/modules/eventos/events_module.dart';
import 'package:conexaoolivia/modules/quem-somos/quem_somos.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';
import 'modules/splash/pages/splash_page.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Registra o AuthStore como singleton
    i.addSingleton<AuthStore>(AuthStore.new);

  }
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const SplashPage());
    r.module('/auth', module: AuthModule());
    r.module('/home', module: HomeModule());
    r.module('/events', module: EventsModule());
    r.module('/quem-somos', module: QuemSomosModule());
  }
}