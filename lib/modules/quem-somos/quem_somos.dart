
import 'package:conexaoolivia/modules/quem-somos/pages/quem_somos_page.dart';
import 'package:conexaoolivia/modules/quem-somos/pages/quem_somos_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuemSomosModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<QuemSomosStore>(() => QuemSomosStore());
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => QuemSomosPage());

  }
}