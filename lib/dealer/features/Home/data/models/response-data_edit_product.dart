
import 'dart:convert';

class dataresponseEditProduct {
  final String name;
  final String description;
  final String price;
  final String discount;
  final int stock;
  final String condition;
  final String category;
  final String material;
  final String color;
  final String warranty;
  final String installationInfo;
  final bool isAvailable;

  dataresponseEditProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.stock,
    required this.condition,
    required this.category,
    required this.material,
    required this.color,
    required this.warranty,
    required this.installationInfo,
    required this.isAvailable,
  });

  dataresponseEditProduct copyWith({
    String? name,
    String? description,
    String? price,
    String? discount,
    int? stock,
    String? condition,
    String? category,
    String? material,
    String? color,
    String? warranty,
    String? installationInfo,
    bool? isAvailable,
  }) {
    return dataresponseEditProduct(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      stock: stock ?? this.stock,
      condition: condition ?? this.condition,
      category: category ?? this.category,
      material: material ?? this.material,
      color: color ?? this.color,
      warranty: warranty ?? this.warranty,
      installationInfo: installationInfo ?? this.installationInfo,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'stock': stock,
      'condition': condition,
      'category': category,
      'material': material,
      'color': color,
      'warranty': warranty,
      'installationInfo': installationInfo,
      'isAvailable': isAvailable,
    };
  }

  factory dataresponseEditProduct.fromMap(Map<String, dynamic> map) {
    return dataresponseEditProduct(
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      discount: map['discount'] as String,
      stock: map['stock'] as int,
      condition: map['condition'] as String,
      category: map['category'] as String,
      material: map['material'] as String,
      color: map['color'] as String,
      warranty: map['warranty'] as String,
      installationInfo: map['installation_info'] as String,
      isAvailable: map['is_available'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory dataresponseEditProduct.fromJson(String source) =>
      dataresponseEditProduct.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
