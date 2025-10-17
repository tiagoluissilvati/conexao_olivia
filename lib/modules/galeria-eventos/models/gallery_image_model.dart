// models/gallery_image_model.dart
class GalleryImage {
  final String id;
  final String galleryEventId;
  final String imageUrl;
  final String imagePath;
  final String? thumbnailUrl;
  final String originalName;
  final int fileSize;
  final String mimeType;
  final int displayOrder;
  final bool isThumbnail; // Nova propriedade
  final DateTime createdAt;

  GalleryImage({
    required this.id,
    required this.galleryEventId,
    required this.imageUrl,
    required this.imagePath,
    this.thumbnailUrl,
    required this.originalName,
    required this.fileSize,
    required this.mimeType,
    required this.displayOrder,
    this.isThumbnail = false, // Padrão false
    required this.createdAt,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'].toString(),
      galleryEventId: json['gallery_event_id'].toString(),
      imageUrl: json['image_url'] ?? '',
      imagePath: json['image_path'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      originalName: json['original_name'] ?? '',
      fileSize: json['file_size'] ?? 0,
      mimeType: json['mime_type'] ?? 'image/jpeg',
      displayOrder: json['display_order'] ?? 0,
      isThumbnail: json['is_thumbnail'] ?? false, // Novo campo
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gallery_event_id': galleryEventId,
      'image_url': imageUrl,
      'image_path': imagePath,
      'thumbnail_url': thumbnailUrl,
      'original_name': originalName,
      'file_size': fileSize,
      'mime_type': mimeType,
      'display_order': displayOrder,
      'is_thumbnail': isThumbnail, // Novo campo
      'created_at': createdAt.toIso8601String(),
    };
  }

  GalleryImage copyWith({
    String? id,
    String? galleryEventId,
    String? imageUrl,
    String? imagePath,
    String? thumbnailUrl,
    String? originalName,
    int? fileSize,
    String? mimeType,
    int? displayOrder,
    bool? isThumbnail, // Novo campo
    DateTime? createdAt,
  }) {
    return GalleryImage(
      id: id ?? this.id,
      galleryEventId: galleryEventId ?? this.galleryEventId,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      originalName: originalName ?? this.originalName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      displayOrder: displayOrder ?? this.displayOrder,
      isThumbnail: isThumbnail ?? this.isThumbnail, // Novo campo
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'GalleryImage(id: $id, originalName: $originalName, isThumbnail: $isThumbnail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GalleryImage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}