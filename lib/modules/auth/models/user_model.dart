// Substitua seu UserModel por esta versão que trata valores null

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? cpf;    // Permitir null
  final String? phone;  // Permitir null
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? needsPasswordChange;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.cpf,           // Opcional
    this.phone,         // Opcional
    required this.createdAt,
    required this.updatedAt,
    this.needsPasswordChange
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 === DEBUG UserModel.fromJson ===');
      print('📄 JSON recebido:');
      json.forEach((key, value) {
        print('   $key: "$value" (${value.runtimeType})');
      });

      // Verificar campos obrigatórios
      if (json['id'] == null) throw Exception('ID é obrigatório');
      if (json['email'] == null) throw Exception('Email é obrigatório');
      if (json['name'] == null) throw Exception('Nome é obrigatório');

      final model = UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        cpf: json['cpf']?.toString(), // Converter para String ou null
        phone: json['phone']?.toString(), // Converter para String ou null
        needsPasswordChange: json['needs_password_change'] != null ? json['needs_password_change'] as bool : false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );

      print('✅ UserModel criado com sucesso');
      print('   CPF: "${model.cpf}"');
      print('   Phone: "${model.phone}"');

      return model;

    } catch (e, stackTrace) {
      print('❌ === ERRO em UserModel.fromJson ===');
      print('   Erro: $e');
      print('   Stack: $stackTrace');
      print('   JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    // Adicionar campos opcionais apenas se não forem null
    if (cpf != null && cpf!.isNotEmpty) {
      json['cpf'] = cpf!;
    }

    if (phone != null && phone!.isNotEmpty) {
      json['phone'] = phone!;
    }
    if (needsPasswordChange != null ) {
      json['needs_password_change'] = needsPasswordChange.toString();
    }

    return json;
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? cpf,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,  bool? needsPasswordChange,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, cpf: $cpf, phone: $phone)';
  }
}