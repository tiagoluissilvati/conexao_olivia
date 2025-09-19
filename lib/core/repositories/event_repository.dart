// repositories/event_repository.dart
import 'package:conexaoolivia/modules/eventos/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


abstract class IEventRepository {
  Future<List<Event>> getFutureEvents();
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(String id);
  Future<Event> createEvent(Event event);
  Future<Event> updateEvent(Event event);
  Future<void> deleteEvent(String id);
  Future<bool> isUserAdmin();
  Future<bool> isUserAuthenticated();
}

class EventRepository implements IEventRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Event>> getFutureEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .gte('event_date', DateTime.now().toIso8601String().split('T')[0])
          .order('event_date', ascending: true);

      return (response as List).map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar eventos futuros: $e');
    }
  }

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .order('event_date', ascending: true);

      return (response as List).map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar todos os eventos: $e');
    }
  }

  @override
  Future<Event?> getEventById(String id) async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .eq('id', id)
          .single();

      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao buscar evento: $e');
    }
  }

  @override
  Future<Event> createEvent(Event event) async {
    try {
      // Verificar se o usuário está autenticado
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Para criação, remover o ID do payload para evitar conflitos
      final eventData = event.toJson();
      eventData.remove('id'); // Garantir que não há ID vazio sendo enviado

      final response = await _supabase
          .from('events')
          .insert(eventData)
          .select()
          .single();

      return Event.fromJson(response);
    } catch (e) {
      if (e is PostgrestException) {
        if (e.code == '42501') {
          throw Exception('Você não tem permissão para criar eventos. Faça login como admin.');
        } else if (e.code == '23503') {
          throw Exception('Erro de autenticação. Faça login novamente.');
        } else if (e.code == '22P02') {
          throw Exception('Erro nos dados enviados. Verifique se todos os campos estão corretos.');
        }
      }
      throw Exception('Erro ao criar evento: $e');
    }
  }

  @override
  Future<Event> updateEvent(Event event) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      if (event.id.isEmpty) {
        throw Exception('ID do evento é obrigatório para atualização');
      }

      // Para atualização, usar apenas os campos que podem ser modificados
      final updateData = event.toJson();
      updateData.remove('id'); // Remover ID do payload, será usado no WHERE

      final response = await _supabase
          .from('events')
          .update(updateData)
          .eq('id', event.id)
          .select()
          .single();

      return Event.fromJson(response);
    } catch (e) {
      if (e is PostgrestException) {
        if (e.code == '42501') {
          throw Exception('Você não tem permissão para editar este evento.');
        } else if (e.code == '22P02') {
          throw Exception('Erro nos dados enviados. Verifique se todos os campos estão corretos.');
        }
      }
      throw Exception('Erro ao atualizar evento: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      await _supabase.from('events').delete().eq('id', id);
    } catch (e) {
      if (e is PostgrestException) {
        if (e.code == '42501') {
          throw Exception('Você não tem permissão para excluir este evento.');
        }
      }
      throw Exception('Erro ao deletar evento: $e');
    }
  }

  @override
  Future<bool> isUserAdmin() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Verificar se o usuário tem role de admin no metadata
      final role = user.userMetadata?['role'];
      return role == 'admin';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isUserAuthenticated() async {
    try {
      final user = _supabase.auth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }
}