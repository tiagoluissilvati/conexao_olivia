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

  // NOVOS CAMPOS
  final bool isFeatured;
  final String? bannerCarouselUrl;
  final String? bannerLargeUrl;

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
    this.linkCheckout,
    this.isFeatured = false,
    this.bannerCarouselUrl,
    this.bannerLargeUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      eventDate: DateTime.parse(json['event_date']),
      eventTime: json['event_time'],
      location: json['location'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      linkCheckout: json['link_checkout'],
      isFeatured: json['is_featured'] ?? false,
      bannerCarouselUrl: json['banner_carousel_url'],
      bannerLargeUrl: json['banner_large_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String(),
      'event_time': eventTime,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'link_checkout': linkCheckout,
      'is_featured': isFeatured,
      'banner_carousel_url': bannerCarouselUrl,
      'banner_large_url': bannerLargeUrl,
    };
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
    String? linkCheckout,
    bool? isFeatured,
    String? bannerCarouselUrl,
    String? bannerLargeUrl,
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
      linkCheckout: linkCheckout ?? this.linkCheckout,
      isFeatured: isFeatured ?? this.isFeatured,
      bannerCarouselUrl: bannerCarouselUrl ?? this.bannerCarouselUrl,
      bannerLargeUrl: bannerLargeUrl ?? this.bannerLargeUrl,
    );
  }

  String get formattedTime {
    if (eventTime == null || eventTime!.isEmpty) return '';
    return eventTime!;
  }

  String get weekDay {
    final weekdays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    return weekdays[eventDate.weekday - 1];
  }

  String getMonthAbbreviation() {
    final months = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
    return months[eventDate.month - 1];
  }

  bool get hasBannerCarousel => bannerCarouselUrl != null && bannerCarouselUrl!.isNotEmpty;
  bool get hasBannerLarge => bannerLargeUrl != null && bannerLargeUrl!.isNotEmpty;
}