// models/event_model.dart
class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? eventTime;
  final String? location;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? linkCheckout;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.eventTime,
    this.location,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.linkCheckout
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventDate: DateTime.parse(json['event_date']),
      eventTime: json['event_time'],
      location: json['location'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      linkCheckout: json['link_checkout']
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'event_date': eventDate.toIso8601String().split('T')[0],
    };

    // Adicionar campos opcionais apenas se não forem nulos/vazios
    if (description != null && description!.isNotEmpty) {
      json['description'] = description;
    }

    if (eventTime != null && eventTime!.isNotEmpty) {
      json['event_time'] = eventTime;
    }

    if (location != null && location!.isNotEmpty) {
      json['location'] = location;
    }

    // Para operações de UPDATE, incluir o ID
    if (id.isNotEmpty) {
      json['id'] = id;
    }

    if (linkCheckout != null && linkCheckout!.isNotEmpty) {
      json['link_checkout'] = linkCheckout;
    }
    // Não incluir: created_by, created_at, updated_at
    // Estes são gerenciados automaticamente pelo Supabase

    return json;
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    String? eventTime,
    String? location,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters para formatação
  String get formattedDate {
    final months = [
      '', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${eventDate.day}\n${months[eventDate.month]}';
  }

  String get weekDay {
    final weekDays = [
      'DOMINGO', 'SEGUNDA-FEIRA', 'TERÇA-FEIRA', 'QUARTA-FEIRA',
      'QUINTA-FEIRA', 'SEXTA-FEIRA', 'SÁBADO'
    ];
    return weekDays[eventDate.weekday % 7];
  }

  String get formattedTime {

    if (eventTime == null || eventTime!.isEmpty) return '';

    // Se já está no formato HH:MM, retornar como está
    if (RegExp(r'^([01]?[0-9]|2[0-3]):([0-5][0-9])$').hasMatch(eventTime!)) {
      return eventTime!;
    }

    // Se está no formato HH:MM:SS, remover os segundos
    if (eventTime!.contains(':')) {
      List<String> parts = eventTime!.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    }

    return eventTime!;
  }

  String getMonthAbbreviation() {
    const months = [
      '', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return months[eventDate.month];
  }
}