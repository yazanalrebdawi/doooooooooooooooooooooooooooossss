
class Car {
  int id;
  // List<String> images;
  String name;
  String brand;
  String model;
  String price;
  String discount;
  int year;
  int kilometers;
  String fuelType;
  String transmission;
  String engineCapacity;
  String driveType;
  String color;
  bool isAvailable;
  int doorsCount;
  int seatsCount;
  String status;
  String licenseStatus;
  String location;
  // dynamic video;

  int dealer;

  Car({
    required this.id,
    // required this.images,
    required this.name,
    required this.brand,
    required this.model,
    required this.price,
    required this.discount,
    required this.year,
    required this.kilometers,
    required this.fuelType,
    required this.transmission,
    required this.engineCapacity,
    required this.driveType,
    required this.color,
    required this.isAvailable,
    required this.doorsCount,
    required this.seatsCount,
    required this.status,
    required this.licenseStatus,
    required this.location,

    // required this.video,
    required this.dealer,
  });

  /// Deserialize from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      // images: json['images'] ?? [],
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      price: json['price'] ?? '',
      discount: json['discount'] ?? '',
      year: json['year'],
      kilometers: json['kilometers'],
      fuelType: json['fuel_type'] ?? '',
      transmission: json['transmission'] ?? '',
      engineCapacity: json['engine_capacity'] ?? '',
      driveType: json['drive_type'] ?? '',
      color: json['color'] ?? '',
      isAvailable: json['is_available'],
      doorsCount: json['doors_count'],
      seatsCount: json['seats_count'],
      status: json['status'] ?? '',
      licenseStatus: json['license_status'] ?? '',
      location: json['location'] ?? '',

      // video: json['video'],
      dealer: json['dealer'],
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'images': images,
      'name': name,
      'brand': brand,
      'model': model,
      'price': price,
      'discount': discount,
      'year': year,
      'kilometers': kilometers,
      'fuelType': fuelType,
      'transmission': transmission,
      'engineCapacity': engineCapacity,
      'driveType': driveType,
      'color': color,
      'isAvailable': isAvailable,
      'doorsCount': doorsCount,
      'seatsCount': seatsCount,
      'status': status,
      'licenseStatus': licenseStatus,
      'location': location,
      // 'video': video,
      'dealer': dealer,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'price': price,
      'discount': discount,
      'year': year,
      'kilometers': kilometers,
      'fuelType': fuelType,
      'transmission': transmission,
      'engineCapacity': engineCapacity,
      'driveType': driveType,
      'color': color,
      'isAvailable': isAvailable,
      'doorsCount': doorsCount,
      'seatsCount': seatsCount,
      'status': status,
      'licenseStatus': licenseStatus,
      'location': location,
      'dealer': dealer,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as int,
      name: map['name'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      price: map['price'] as String,
      discount: map['discount'] as String,
      year: map['year'] as int,
      kilometers: map['kilometers'] as int,
      fuelType: map['fuelType'] as String,
      transmission: map['transmission'] as String,
      engineCapacity: map['engineCapacity'] as String,
      driveType: map['driveType'] as String,
      color: map['color'] as String,
      isAvailable: map['isAvailable'] as bool,
      doorsCount: map['doorsCount'] as int,
      seatsCount: map['seatsCount'] as int,
      status: map['status'] as String,
      licenseStatus: map['licenseStatus'] as String,
      location: map['location'] as String,
      dealer: map['dealer'] as int,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Car.fromJson(String source) => Car.fromMap(json.decode(source) as Map<String, dynamic>);
}
