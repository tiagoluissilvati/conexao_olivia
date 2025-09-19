import 'package:conexaoolivia/modules/eventos/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Buscar eventos futuros
  Future<List<Event>> getFutureEvents() async {
    final response = await _supabase
        .from('events')
        .select()
        .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
        .order('event_date', ascending: true);

    return (response as List).map((json) => Event.fromJson(json)).toList();
  }

  // Buscar todos os eventos (admin)
  Future<List<Event>> getAllEvents() async {
    final response = await _supabase
        .from('events')
        .select()
        .order('event_date', ascending: true);

    return (response as List).map((json) => Event.fromJson(json)).toList();
  }

  // Buscar evento por ID
  Future<Event?> getEventById(String id) async {
    final response = await _supabase
        .from('events')
        .select()
        .eq('id', id)
        .single();

    return Event.fromJson(response);
  }

  // Criar evento
  Future<Event> createEvent(Event event) async {
    final response = await _supabase
        .from('events')
        .insert(event.toJson())
        .select()
        .single();

    return Event.fromJson(response);
  }

  // Atualizar evento
  Future<Event> updateEvent(Event event) async {
    final response = await _supabase
        .from('events')
        .update(event.toJson())
        .eq('id', event.id)
        .select()
        .single();

    return Event.fromJson(response);
  }

  // Deletar evento
  Future<void> deleteEvent(String id) async {
    await _supabase.from('events').delete().eq('id', id);
  }

  // Verificar se usuário é admin
  Future<bool> isUserAdmin() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    // Verificar se o usuário tem role de admin
    final role = user.userMetadata?['role'];
    return role == 'admin';
  }
}