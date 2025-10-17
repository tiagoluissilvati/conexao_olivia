import 'package:conexaoolivia/core/repositories/event_repository.dart';
import 'package:conexaoolivia/modules/eventos/pages/agenda_page.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_detail_page.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_form_page.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_form_store.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class EventsModule extends Module {
  @override
  void binds(i) {
    // Repository
    i.addLazySingleton<IEventRepository>(() =>  EventRepository(Supabase.instance.client));


    // Stores
    i.addSingleton<EventStore>(() => EventStore(i.get<IEventRepository>()));
    i.addSingleton<EventFormStore>(() => EventFormStore());
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => AgendaPage());
    r.child('/detail', child: (context) => EventDetailPage());
    r.child('/form', child: (context) => EventFormPage());
  }
}
