import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class ProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final List<String> images;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String location;

  @HiveField(8)
  final double rating;

  @HiveField(9)
  final List<String> reviews;

  @HiveField(10)
  final bool isFavorite;

  @HiveField(11)
  final int sellerId;

  @HiveField(12)
  final int stock;

  @HiveField(13)
  final double discount;

  @HiveField(14)
  final double finalPrice;

  @HiveField(15)
  final String condition;

  @HiveField(16)
  final String material;

  @HiveField(17)
  final String color;

  @HiveField(18)
  final String warranty;

  @HiveField(19)
  final String installationInfo;

  @HiveField(20)
  final String createdAt;

  @HiveField(21)
  final int dealer;

  @HiveField(22)
  final Map<String, dynamic> seller;

  @HiveField(23)
  final String locationText;

  @HiveField(24)
  final Map<String, dynamic>? locationCoords;

  @HiveField(25)
  final String availabilityText;

  @HiveField(26)
  final bool isInStock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.images = const [],
    required this.category,
    this.location = '',
    this.rating = 0.0,
    this.reviews = const [],
    this.isFavorite = false,
    this.sellerId = 1,
    this.stock = 0,
    this.discount = 0.0,
    this.finalPrice = 0.0,
    this.condition = '',
    this.material = '',
    this.color = '',
    this.warranty = '',
    this.installationInfo = '',
    this.createdAt = '',
    this.dealer = 1,
    this.seller = const {},
    this.locationText = '',
    this.locationCoords,
    this.availabilityText = '',
    this.isInStock = false,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    List<String>? images,
    String? category,
    String? location,
    double? rating,
    List<String>? reviews,
    bool? isFavorite,
    int? sellerId,
    int? stock,
    double? discount,
    double? finalPrice,
    String? condition,
    String? material,
    String? color,
    String? warranty,
    String? installationInfo,
    String? createdAt,
    int? dealer,
    Map<String, dynamic>? seller,
    String? locationText,
    Map<String, dynamic>? locationCoords,
    String? availabilityText,
    bool? isInStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
      sellerId: sellerId ?? this.sellerId,
      stock: stock ?? this.stock,
      discount: discount ?? this.discount,
      finalPrice: finalPrice ?? this.finalPrice,
      condition: condition ?? this.condition,
      material: material ?? this.material,
      color: color ?? this.color,
      warranty: warranty ?? this.warranty,
      installationInfo: installationInfo ?? this.installationInfo,
      createdAt: createdAt ?? this.createdAt,
      dealer: dealer ?? this.dealer,
      seller: seller ?? this.seller,
      locationText: locationText ?? this.locationText,
      locationCoords: locationCoords ?? this.locationCoords,
      availabilityText: availabilityText ?? this.availabilityText,
      isInStock: isInStock ?? this.isInStock,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'location': location,
      'rating': rating,
      'reviews': reviews,
      'isFavorite': isFavorite,
      'sellerId': sellerId,
      'stock': stock,
      'discount': discount,
      'final_price': finalPrice,
      'condition': condition,
      'material': material,
      'color': color,
      'warranty': warranty,
      'installation_info': installationInfo,
      'created_at': createdAt,
      'dealer': dealer,
      'seller': seller,
      'location_text': locationText,
      'location_coords': locationCoords,
      'availability_text': availabilityText,
      'is_in_stock': isInStock,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle price as string from API
    double parsePrice(dynamic price) {
      if (price is String) {
        return double.tryParse(price) ?? 0.0;
      } else if (price is num) {
        return price.toDouble();
      }
      return 0.0;
    }

    // Handle discount as string from API
    double parseDiscount(dynamic discount) {
      if (discount is String) {
        return double.tryParse(discount) ?? 0.0;
      } else if (discount is num) {
        return discount.toDouble();
      }
      return 0.0;
    }

    // Handle final_price as string from API
    double parseFinalPrice(dynamic finalPrice) {
      if (finalPrice is String) {
        return double.tryParse(finalPrice) ?? 0.0;
      } else if (finalPrice is num) {
        return finalPrice.toDouble();
      }
      return 0.0;
    }

    // Get image URL from main_image field
    String getImageUrl(dynamic mainImage) {
      if (mainImage is String && mainImage.isNotEmpty) {
        // Add base URL if the image path starts with /
        if (mainImage.startsWith('/')) {
          return 'http://192.168.138.185:8010$mainImage';
        }
        return mainImage;
      }
      return '';
    }

    // Extract image URLs from images array (if available)
    List<String> getImageUrls(dynamic images) {
      if (images is List) {
        return images
            .map((img) {
              if (img is String) {
                return img;
              } else if (img is Map && img['image'] != null) {
                return img['image'].toString();
              }
              return '';
            })
            .where((url) => url.isNotEmpty)
            .toList();
      }
      return [];
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: parsePrice(json['price']),
      description: json['description'] ?? '',
      imageUrl: getImageUrl(json['main_image']), // API uses 'main_image' field
      images: getImageUrls(json['images']),
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: List<String>.from(json['reviews'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      sellerId: json['dealer'] ?? 1, // Use dealer as sellerId
      stock: json['stock'] ?? 0,
      discount: parseDiscount(json['discount']),
      finalPrice: parseFinalPrice(json['final_price']),
      condition: json['condition'] ?? '',
      material: json['material'] ?? '',
      color: json['color'] ?? '',
      warranty: json['warranty'] ?? '',
      installationInfo: json['installation_info'] ?? '',
      createdAt: json['created_at'] ?? '',
      dealer: json['dealer'] ?? 1,
      seller: json['seller'] ?? {},
      locationText: json['location_text'] ?? '',
      locationCoords: json['location_coords'],
      availabilityText: json['availability_text'] ?? '',
      isInStock: json['is_in_stock'] ?? false,
    );
  }
}
