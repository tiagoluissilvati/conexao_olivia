// modules/parceiras/partners_module.dart
import 'package:conexaoolivia/modules/parceiras/pages/partner_detail_page.dart';
import 'package:conexaoolivia/modules/parceiras/pages/partner_form_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/repositories/partner_repository.dart';
import 'pages/partner_form_store.dart';
import 'pages/partner_store.dart';
import 'pages/partners_list_page.dart';

class PartnersModule extends Module {
  @override
  void binds(i) {
    // Repository
    i.addLazySingleton<IPartnerRepository>(() =>  PartnerRepository(Supabase.instance.client));

    // Stores
    i.addSingleton<PartnerStore>(() => PartnerStore(i.get<IPartnerRepository>()));
    i.addSingleton<PartnerFormStore>(() => PartnerFormStore());
   }

  @override
  void routes(r) {
    r.child('/', child: (context) => PartnersListPage());
    r.child('/detail', child: (context) => PartnerDetailPage());
    r.child('/form', child: (context) => PartnerFormPage());
  }
}