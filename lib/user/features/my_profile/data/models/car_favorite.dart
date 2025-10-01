// import 'package:hive/hive.dart';

// part 'car_favorite.g.dart';

// @HiveType(typeId: 3)
// class CarFavorite {
//   @HiveField(0)
//   final int id;

//   @HiveField(1)
//   final DateTime createdAt;

//   @HiveField(2)
//   final String targetType;

//   @HiveField(3)
//   final int targetId;

//   @HiveField(4)
//   final CarTargetModel target;

//   CarFavorite({
//     required this.id,
//     required this.createdAt,
//     required this.targetType,
//     required this.targetId,
//     required this.target,
//   });

//   factory CarFavorite.fromJson(Map<String, dynamic> json) {
//     return CarFavorite(
//       id: (json['id'] ?? 0) as int,
//       createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
//       targetType: json['target_type'] ?? "",
//       targetId: (json['target_id'] ?? 0) as int,
//       target: CarTargetModel.fromJson(json['target'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'created_at': createdAt.toIso8601String(),
//       'target_type': targetType,
//       'target_id': targetId,
//       'target': target.toJson(),
//     };
//   }
// }

// @HiveType(typeId: 4)
// class CarTargetModel {
//   @HiveField(0)
//   final int id;

//   @HiveField(1)
//   final String name;

//   @HiveField(2)
//   final String brand;

//   @HiveField(3)
//   final String model;

//   @HiveField(4)
//   final String price;

//   @HiveField(5)
//   final String discount;

//   @HiveField(6)
//   final DateTime createdAt;

//   @HiveField(7)
//   final String mainImage;

//   CarTargetModel({
//     required this.id,
//     required this.name,
//     required this.brand,
//     required this.model,
//     required this.price,
//     required this.discount,
//     required this.createdAt,
//     required this.mainImage,
//   });

//   factory CarTargetModel.fromJson(Map<String, dynamic> json) {
//     return CarTargetModel(
//       id: (json['id'] ?? 0) as int,
//       name: json['name'] ?? "",
//       brand: json['brand'] ?? "",
//       model: json['model'] ?? "",
//       price: json['price']?.toString() ?? "",
//       discount: json['discount']?.toString() ?? "",
//       createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
//       mainImage: json['main_image'] as String? ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'brand': brand,
//       'model': model,
//       'price': price,
//       'discount': discount,
//       'created_at': createdAt.toIso8601String(),
//       'main_image': mainImage,
//     };
//   }
// }
