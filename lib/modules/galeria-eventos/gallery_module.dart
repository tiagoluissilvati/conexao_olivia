// modules/gallery/gallery_module.dart
import 'package:conexaoolivia/core/repositories/gallery_repository.dart';
import 'package:conexaoolivia/modules/galeria-eventos/pages/gallery_form_store.dart';
import 'package:conexaoolivia/modules/galeria-eventos/pages/gallery_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'pages/gallery_page.dart';
import 'pages/gallery_detail_page.dart';
import 'pages/gallery_form_page.dart';

class GalleryModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<IGalleryRepository>(() => GalleryRepository());

    i.addSingleton<GalleryStore>(() => GalleryStore(i.get<IGalleryRepository>()));

    i.addSingleton<GalleryFormStore>(() => GalleryFormStore());
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => GalleryPage());
    r.child('/detail', child: (context) => GalleryDetailPage());
    r.child('/form', child: (context) => GalleryFormPage());
  }
}