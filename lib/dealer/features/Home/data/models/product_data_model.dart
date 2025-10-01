// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class productdata {
  int id;
  String name;
  String price;
  String discount;
  String finalPrice;
  dynamic mainImage;
  String category;
  bool isAvailable;

  productdata({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.finalPrice,
    required this.mainImage,
    required this.category,
    required this.isAvailable,
  });

  productdata copyWith({
    int? id,
    String? name,
    String? price,
    String? discount,
    String? finalPrice,
    dynamic? mainImage,
    String? category,
    bool? isAvailable,
  }) {
    return productdata(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      finalPrice: finalPrice ?? this.finalPrice,
      mainImage: mainImage ?? this.mainImage,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'discount': discount,
      'finalPrice': finalPrice,
      'mainImage': mainImage,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  factory productdata.fromMap(Map<String, dynamic> map) {
    return productdata(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as String,
      discount: map['discount'] as String,
      finalPrice: map['final_price'] as String,
      mainImage: map['main_image'] as dynamic,
      category: map['category'] as String,
      isAvailable: map['is_available'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory productdata.fromJson(String source) =>
      productdata.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ResponseDataProduct {
  final int id;
  final List<dynamic> images;
  final String? name;
  final String? description;
  final String? price;
  final String? discount;
  final String? finalPrice;
  final int stock;
  final String? condition;
  final String? category;
  final dynamic material;
  final dynamic color;
  final dynamic warranty;
  final dynamic installationInfo;
  // final DateTime createdAt;
  final int dealer;
  final Seller seller;
  // final dynamic locationText;
  // final dynamic locationCoords;
  final String? availabilityText;
  final bool isInStock;

  ResponseDataProduct({
    required this.id,
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.finalPrice,
    required this.stock,
    required this.condition,
    required this.category,
    required this.material,
    required this.color,
    required this.warranty,
    required this.installationInfo,
    // required this.createdAt,
    required this.dealer,
    required this.seller,
    // required this.locationText,
    // required this.locationCoords,
    required this.availabilityText,
    required this.isInStock,
  });

  ResponseDataProduct copyWith({
    int? id,
    List<dynamic>? images,
    String? name,
    String? description,
    String? price,
    String? discount,
    String? finalPrice,
    int? stock,
    String? condition,
    String? category,
    dynamic material,
    dynamic color,
    dynamic warranty,
    dynamic installationInfo,
    // DateTime? createdAt,
    int? dealer,
    Seller? seller,
    // dynamic locationText,
    // dynamic locationCoords,
    String? availabilityText,
    bool? isInStock,
  }) => ResponseDataProduct(
    id: id ?? this.id,
    images: images ?? this.images,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    discount: discount ?? this.discount,
    finalPrice: finalPrice ?? this.finalPrice,
    stock: stock ?? this.stock,
    condition: condition ?? this.condition,
    category: category ?? this.category,
    material: material ?? this.material,
    color: color ?? this.color,
    warranty: warranty ?? this.warranty,
    installationInfo: installationInfo ?? this.installationInfo,
    // createdAt: createdAt ?? this.createdAt,
    dealer: dealer ?? this.dealer,
    seller: seller ?? this.seller,
    // locationText: locationText ?? this.locationText,
    // locationCoords: locationCoords ?? this.locationCoords,
    availabilityText: availabilityText ?? this.availabilityText,
    isInStock: isInStock ?? this.isInStock,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'images': images,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'finalPrice': finalPrice,
      'stock': stock,
      'condition': condition,
      'category': category,
      'material': material,
      'color': color,
      'warranty': warranty,
      'installationInfo': installationInfo,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
      'dealer': dealer,
      'seller': seller.toMap(),
      // 'locationText': locationText,
      // 'locationCoords': locationCoords,
      'availabilityText': availabilityText,
      'isInStock': isInStock,
    };
  }

  factory ResponseDataProduct.fromMap(Map<String, dynamic> map) {
    return ResponseDataProduct(
      id: map['id'] as int,
      images: List<dynamic>.from(map['images'] as List<dynamic>), // ✅ صح
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      discount: map['discount'] as String,
      finalPrice: map['final_price'] as String,
      stock: map['stock'] as int,
      condition: map['condition'] as String,
      category: map['category'] as String,
      material: map['material'],
      color: map['color'],
      warranty: map['warranty'],
      installationInfo: map['installation_info'],
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      dealer: map['dealer'] as int,
      seller: Seller.fromMap(map['seller'] as Map<String, dynamic>),
      // locationText: map['locationText'],
      // locationCoords: map['locationCoords'],
      availabilityText: map['availabilityText'] as String,
      isInStock: map['isInStock'] as bool,
    );
  }
  String toJson() => json.encode(toMap());

  factory ResponseDataProduct.fromJson(String source) =>
      ResponseDataProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Seller {
  final int id;
  final String name;
  final dynamic profileImage;
  final String phone;

  Seller({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.phone,
  });

  Seller copyWith({
    int? id,
    String? name,
    dynamic profileImage,
    String? phone,
  }) => Seller(
    id: id ?? this.id,
    name: name ?? this.name,
    profileImage: profileImage ?? this.profileImage,
    phone: phone ?? this.phone,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'phone': phone,
    };
  }

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'] as int,
      name: map['name'] as String,
      profileImage: map['profile_image'] as dynamic,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Seller.fromJson(String source) =>
      Seller.fromMap(json.decode(source) as Map<String, dynamic>);
}
