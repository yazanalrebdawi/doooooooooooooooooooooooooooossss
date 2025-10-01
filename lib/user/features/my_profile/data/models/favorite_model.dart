import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 7)
class FavoriteModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final String targetType; // "car" أو "product"

  @HiveField(3)
  final int targetId;

  @HiveField(4)
  final TargetModel target;

  FavoriteModel({
    required this.id,
    required this.createdAt,
    required this.targetType,
    required this.targetId,
    required this.target,
  });

  /// fromJson
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: (json['id'] ?? 0) as int,
      createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
      targetType: json['target_type'] ?? "",
      targetId: (json['target_id'] ?? 0) as int,
      target: TargetModel.fromJson(json['target'] ?? {}, json['target_type']),
    );
  }

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'target_type': targetType,
      'target_id': targetId,
      'target': target.toJson(),
    };
  }
}

@HiveType(typeId: 8)
class TargetModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String brand; // خاص بالـ Car، Product يتركه فارغ ""

  @HiveField(3)
  final String model; // خاص بالـ Car، Product يتركه فارغ ""

  @HiveField(4)
  final String price;

  @HiveField(5)
  final String discount;

  @HiveField(6)
  final String finalPrice; // خاص بالـ Product، Car يتركه مثل price

  @HiveField(7)
  final DateTime createdAt; // موجود للسيارات، Product نقدر نخليه DateTime.now() إذا غير موجود

  @HiveField(8)
  final String mainImage;

  @HiveField(9)
  final String category; // خاص بالـ Product، Car يتركه ""

  TargetModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.price,
    required this.discount,
    required this.finalPrice,
    required this.createdAt,
    required this.mainImage,
    required this.category,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json, String? type) {
    final isCar = type == "car";

    return TargetModel(
      id: (json['id'] ?? 0) as int,
      name: json['name'] ?? "",
      brand: isCar ? json['brand'] ?? "" : "",
      model: isCar ? json['model'] ?? "" : "",
      price: json['price']?.toString() ?? "",
      discount: json['discount']?.toString() ?? "",
      finalPrice:
          isCar
              ? (json['price']?.toString() ?? "")
              : (json['final_price']?.toString() ?? ""),
      createdAt:
          isCar
              ? DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now()
              : DateTime.now(),
      mainImage: json['main_image'] as String? ?? "",
      category: isCar ? "" : (json['category'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'price': price,
      'discount': discount,
      'final_price': finalPrice,
      'created_at': createdAt.toIso8601String(),
      'main_image': mainImage,
      'category': category,
    };
  }
}
