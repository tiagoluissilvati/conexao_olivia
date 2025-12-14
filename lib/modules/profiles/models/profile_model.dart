
class Profile {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? cpf;
  final String? avatarUrl;
  final String? observacoes;
  final bool isAdmin;
  final bool needsPasswordChange;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.cpf,
    this.avatarUrl,
    this.observacoes,
    required this.isAdmin,
    required this.needsPasswordChange,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      cpf: json['cpf'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      observacoes: json['observacoes'] as String?,
      isAdmin: json['is_admin'] as bool? ?? false,
      needsPasswordChange: json['needs_password_change'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'cpf': cpf,
      'avatar_url': avatarUrl,
      'observacoes': observacoes,
      'is_admin': isAdmin,
      'needs_password_change': needsPasswordChange,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? cpf,
    String? avatarUrl,
    String? observacoes,
    bool? isAdmin,
    bool? needsPasswordChange,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cpf: cpf ?? this.cpf,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      observacoes: observacoes ?? this.observacoes,
      isAdmin: isAdmin ?? this.isAdmin,
      needsPasswordChange: needsPasswordChange ?? this.needsPasswordChange,
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

  String get displayName => name ?? email.split('@').first;

  String get formattedCpf {
    if (cpf == null || cpf!.length != 11) return cpf ?? '';
    return '${cpf!.substring(0, 3)}.${cpf!.substring(3, 6)}.${cpf!.substring(6, 9)}-${cpf!.substring(9, 11)}';
  }

  String get formattedPhone {
    if (phone == null || phone!.isEmpty) return '';
    final cleaned = phone!.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 11) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 7)}-${cleaned.substring(7)}';
    } else if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
    }
    return phone!;
  }
}