// ignore_for_file: public_member_api_docs, sort_constructors_first
class EditUserModel {
  final String name;
  final String phone;
  final double latitude;
  final double longitude;
  final String? avatar;

  EditUserModel({
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    this.avatar,
  });

  factory EditUserModel.fromMap(Map<String, dynamic> map) {
    return EditUserModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      latitude:
          map['latitude'] is int
              ? (map['latitude'] as int).toDouble()
              : (map['latitude'] ?? 0.0).toDouble(),
      longitude:
          map['longitude'] is int
              ? (map['longitude'] as int).toDouble()
              : (map['longitude'] ?? 0.0).toDouble(),
      avatar: map['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'avatar': avatar, // بنرسل الرابط إذا موجود
    };
  }

  EditUserModel copyWith({
    String? name,
    String? phone,
    double? latitude,
    double? longitude,
    String? avatar,
  }) {
    return EditUserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      avatar: avatar ?? this.avatar,
    );
  }
}
