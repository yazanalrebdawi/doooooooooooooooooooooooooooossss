import 'package:hive/hive.dart';
part 'car_model.g.dart'; 

@HiveType(typeId: 0)
class CarModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final bool isNew;

  @HiveField(5)
  final String location;

  @HiveField(6)
  final String mileage;

  @HiveField(7)
  final int year;

  @HiveField(8)
  final String transmission;

  @HiveField(9)
  final String engine;

  @HiveField(10)
  final String fuelType;

  @HiveField(11)
  final String color;

  @HiveField(12)
  final int doors;

  @HiveField(13)
  final String sellerNotes;

  @HiveField(14)
  final String sellerName;

  @HiveField(15)
  final String sellerType;

  @HiveField(16)
  final String sellerImage;

  @HiveField(17)
  final int dealerId;

  @HiveField(18)
  final String brand;

  @HiveField(19)
  final bool isFavorite;


  const CarModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.isNew,
    required this.location,
    required this.mileage,
    required this.year,
    required this.transmission,
    required this.engine,
    required this.fuelType,
    required this.color,
    required this.doors,
    required this.sellerNotes,
    required this.sellerName,
    required this.sellerType,
    required this.sellerImage,
    required this.dealerId,
    this.brand = '',
    this.isFavorite = false,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    // Handle price as string from API
    double parsePrice(dynamic price) {
      if (price is String) {
        return double.tryParse(price) ?? 0.0;
      } else if (price is num) {
        return price.toDouble();
      }
      return 0.0;
    }

    // Get first image from images array or use empty string
    String getImageUrl(dynamic images) {
      if (images is List && images.isNotEmpty) {
        final firstImage = images.first;
        if (firstImage is String) {
          return firstImage;
        } else if (firstImage is Map && firstImage['image'] != null) {
          return firstImage['image'].toString();
        }
      }
      return '';
    }

    // Parse location from SRID format
    String parseLocation(dynamic location) {
      if (location is String && location.startsWith('SRID=4326;POINT')) {
        // Extract coordinates from SRID format
        final coordsMatch = RegExp(r'POINT \(([^)]+)\)').firstMatch(location);
        if (coordsMatch != null) {
          final coords = coordsMatch.group(1)?.split(' ') ?? [];
          if (coords.length >= 2) {
            final lat = double.tryParse(coords[1]) ?? 0.0;
            final lng = double.tryParse(coords[0]) ?? 0.0;
            return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
          }
        }
      }
      return location?.toString() ?? '';
    }

    return CarModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: getImageUrl(json['images']), // API uses 'images' array
      price: parsePrice(json['price']),
      isNew: json['status'] == 'new' || json['status'] == 'Zero', // Map status to isNew
      location: parseLocation(json['location']),
      mileage: json['kilometers']?.toString() ?? '',
      year: json['year'] ?? 0,
      transmission: json['transmission'] ?? '',
      engine: json['engine_capacity'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      color: json['color'] ?? '',
      doors: json['doors_count'] ?? 0,
      sellerNotes: json['license_status'] ?? '',
      sellerName: '', // Not provided in API
      sellerType: '', // Not provided in API
      sellerImage: '', // Not provided in API
      dealerId: json['dealer'] ?? 0,
      brand: json['brand'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'is_new': isNew,
      'location': location,
      'mileage': mileage,
      'year': year,
      'transmission': transmission,
      'engine': engine,
      'fuel_type': fuelType,
      'color': color,
      'doors': doors,
      'seller_notes': sellerNotes,
      'seller_name': sellerName,
      'seller_type': sellerType,
      'seller_image': sellerImage,
      'dealer_id': dealerId,
      'brand': brand,
      'isFavorite': isFavorite,
    };
  }

  CarModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    double? price,
    bool? isNew,
    String? location,
    String? mileage,
    int? year,
    String? transmission,
    String? engine,
    String? fuelType,
    String? color,
    int? doors,
    String? sellerNotes,
    String? sellerName,
    String? sellerType,
    String? sellerImage,
    int? dealerId,
    String? brand,
    bool? isFavorite,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isNew: isNew ?? this.isNew,
      location: location ?? this.location,
      mileage: mileage ?? this.mileage,
      year: year ?? this.year,
      transmission: transmission ?? this.transmission,
      engine: engine ?? this.engine,
      fuelType: fuelType ?? this.fuelType,
      color: color ?? this.color,
      doors: doors ?? this.doors,
      sellerNotes: sellerNotes ?? this.sellerNotes,
      sellerName: sellerName ?? this.sellerName,
      sellerType: sellerType ?? this.sellerType,
      sellerImage: sellerImage ?? this.sellerImage,
      dealerId: dealerId ?? this.dealerId,
      brand: brand ?? this.brand,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

}
