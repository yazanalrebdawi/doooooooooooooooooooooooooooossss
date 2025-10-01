class ServiceModel {
  final int id;
  final String name;
  final String type;
  final String city;
  final String address;
  final String? image;
  final String phonePrimary;
  final String phoneSecondary;
  final bool open24h;
  final String? openFrom;
  final String? openTo;
  final bool openNow;
  final String openingText;
  final double lat;
  final double lon;
  final String callUrl;
  final String mapsUrl;
  final String osmMapsUrl;
  final String geoUrl;
  final String staticMapUrl;
  final bool hasPhone;
  final List<String> services;
  final double? distance; // Distance from user location in meters

  const ServiceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.address,
    this.image,
    required this.phonePrimary,
    required this.phoneSecondary,
    required this.open24h,
    this.openFrom,
    this.openTo,
    required this.openNow,
    required this.openingText,
    required this.lat,
    required this.lon,
    required this.callUrl,
    required this.mapsUrl,
    required this.osmMapsUrl,
    required this.geoUrl,
    required this.staticMapUrl,
    required this.hasPhone,
    required this.services,
    this.distance,
  });

  ServiceModel copyWith({
    int? id,
    String? name,
    String? type,
    String? city,
    String? address,
    String? image,
    String? phonePrimary,
    String? phoneSecondary,
    bool? open24h,
    String? openFrom,
    String? openTo,
    bool? openNow,
    String? openingText,
    double? lat,
    double? lon,
    String? callUrl,
    String? mapsUrl,
    String? osmMapsUrl,
    String? geoUrl,
    String? staticMapUrl,
    bool? hasPhone,
    List<String>? services,
    double? distance,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      city: city ?? this.city,
      address: address ?? this.address,
      image: image ?? this.image,
      phonePrimary: phonePrimary ?? this.phonePrimary,
      phoneSecondary: phoneSecondary ?? this.phoneSecondary,
      open24h: open24h ?? this.open24h,
      openFrom: openFrom ?? this.openFrom,
      openTo: openTo ?? this.openTo,
      openNow: openNow ?? this.openNow,
      openingText: openingText ?? this.openingText,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      callUrl: callUrl ?? this.callUrl,
      mapsUrl: mapsUrl ?? this.mapsUrl,
      osmMapsUrl: osmMapsUrl ?? this.osmMapsUrl,
      geoUrl: geoUrl ?? this.geoUrl,
      staticMapUrl: staticMapUrl ?? this.staticMapUrl,
      hasPhone: hasPhone ?? this.hasPhone,
      services: services ?? this.services,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'city': city,
      'address': address,
      'image': image,
      'phone_primary': phonePrimary,
      'phone_secondary': phoneSecondary,
      'open_24h': open24h,
      'open_from': openFrom,
      'open_to': openTo,
      'open_now': openNow,
      'opening_text': openingText,
      'lat': lat,
      'lon': lon,
      'call_url': callUrl,
      'maps_url': mapsUrl,
      'osm_maps_url': osmMapsUrl,
      'geo_url': geoUrl,
      'static_map_url': staticMapUrl,
      'has_phone': hasPhone,
      'services': services,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      image: json['image'],
      phonePrimary: json['phone_primary'] ?? '',
      phoneSecondary: json['phone_secondary'] ?? '',
      open24h: json['open_24h'] ?? false,
      openFrom: json['open_from'],
      openTo: json['open_to'],
      openNow: json['open_now'] ?? false,
      openingText: json['opening_text'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      callUrl: json['call_url'] ?? '',
      mapsUrl: json['maps_url'] ?? '',
      osmMapsUrl: json['osm_maps_url'] ?? '',
      geoUrl: json['geo_url'] ?? '',
      staticMapUrl: json['static_map_url'] ?? '',
      hasPhone: json['has_phone'] ?? false,
      services: List<String>.from(json['services'] ?? []),
    );
  }

}
