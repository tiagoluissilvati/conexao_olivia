// modules/parceiras/models/partner_model.dart
class Partner {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final String? logoUrl;
  final bool isActive;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Partner({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.logoUrl,
    required this.isActive,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      logoUrl: json['logo_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'address': address,
      'logo_url': logoUrl,
      'is_active': isActive,
      'updated_at': updatedAt.toIso8601String(),
    };

    // Só incluir id se não for vazio
    if (id.isNotEmpty) {
      map['id'] = id;
    }

    // Só incluir created_by se não for null
    if (createdBy != null) {
      map['created_by'] = createdBy;
    }

    // Só incluir created_at se não for vazio
    if (id.isNotEmpty) {
      map['created_at'] = createdAt.toIso8601String();
    }

    return map;
  }

  Partner copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? logoUrl,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String getFormattedCreatedDate() {
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${createdAt.day} de ${months[createdAt.month - 1]} de ${createdAt.year}';
  }
}