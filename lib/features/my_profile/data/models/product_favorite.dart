// import 'package:hive/hive.dart';
// part 'product_favorite.g.dart';

// @HiveType(typeId: 5)
// class ProductFavorite {
//   @HiveField(0)
//   final int id;

//   @HiveField(1)
//   final DateTime createdAt;

//   @HiveField(2)
//   final String targetType;

//   @HiveField(3)
//   final int targetId;

//   @HiveField(4)
//   final ProductTargetModel target;

//   ProductFavorite({
//     required this.id,
//     required this.createdAt,
//     required this.targetType,
//     required this.targetId,
//     required this.target,
//   });

//   factory ProductFavorite.fromJson(Map<String, dynamic> json) {
//     return ProductFavorite(
//       id: (json['id'] ?? 0) as int,
//       createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
//       targetType: json['target_type'] ?? "",
//       targetId: (json['target_id'] ?? 0) as int,
//       target: ProductTargetModel.fromJson(json['target'] ?? {}),
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

// @HiveType(typeId: 6)
// class ProductTargetModel {
//   @HiveField(0)
//   final int id;

//   @HiveField(1)
//   final String name;

//   @HiveField(2)
//   final String price;

//   @HiveField(3)
//   final String discount;

//   @HiveField(4)
//   final String finalPrice;

//   @HiveField(5)
//   final String mainImage;

//   @HiveField(6)
//   final String category;

//   ProductTargetModel({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.discount,
//     required this.finalPrice,
//     required this.mainImage,
//     required this.category,
//   });

//   factory ProductTargetModel.fromJson(Map<String, dynamic> json) {
//     return ProductTargetModel(
//       id: (json['id'] ?? 0) as int,
//       name: json['name'] ?? "",
//       price: json['price']?.toString() ?? "",
//       discount: json['discount']?.toString() ?? "",
//       finalPrice: json['final_price']?.toString() ?? "",
//       mainImage: json['main_image'] as String? ?? "",
//       category: json['category'] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//       'discount': discount,
//       'final_price': finalPrice,
//       'main_image': mainImage,
//       'category': category,
//     };
//   }
// }
