import 'dart:io';

class UserModel {
  final int id;
  final String name;
  final String phone;
  final String role;
  final bool verified;
  final dynamic latitude;
  final dynamic longitude;
  final DateTime createdAt;
  final File? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.verified,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.avatar,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? role,
    bool? verified,
    dynamic latitude,
    dynamic longitude,
    DateTime? createdAt,
    File? avatar,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    verified: verified ?? this.verified,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    createdAt: createdAt ?? this.createdAt,
    avatar: avatar ?? this.avatar,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'verified': verified,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'avatar': avatar?.path,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      verified: map['verified'] ?? false,
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      avatar: map['avatar'] != null ? File(map['avatar']) : null,
    );
  }
}
