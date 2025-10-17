// models/gallery_event_model.dart
import 'package:intl/intl.dart';
import 'gallery_image_model.dart';

class GalleryEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<GalleryImage> images;

  GalleryEvent({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.images = const [],
  });

  factory GalleryEvent.fromJson(Map<String, dynamic> json) {
    return GalleryEvent(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'],
      eventDate: DateTime.parse(json['event_date']),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: json['gallery_images'] != null
          ? (json['gallery_images'] as List)
          .map((imageJson) => GalleryImage.fromJson(imageJson))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String(),
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  GalleryEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<GalleryImage>? images,
  }) {
    return GalleryEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(eventDate);
  }

  String get formattedDateTime {
    return DateFormat('dd/MM/yyyy HH:mm').format(eventDate);
  }

  bool get hasImages => images.isNotEmpty;


  GalleryImage? get thumbnailImage {
    if (images.isEmpty) return null;

    // Procurar imagem marcada como thumbnail
    try {
      return images.firstWhere((image) => image.isThumbnail);
    } catch (e) {
      // Se não encontrar nenhuma marcada como thumbnail, retornar a primeira
      return images.first;
    }
  }

  // NOVO: Verifica se tem uma imagem thumbnail específica marcada
  bool get hasCustomThumbnail => images.any((image) => image.isThumbnail);

  @override
  String toString() {
    return 'GalleryEvent(id: $id, title: $title, imagesCount: ${images.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GalleryEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

}