import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataProfileModel {
  final int id;
  final String name;
  final String storeDescription;
  final int reelsCount;
  final int carsActive;
  final int carsSold;
  final String handle;
  final String phone;
  final int monthlyReelsLimit;
  final String contactPhone;
  final String locationAddress;
  final String googleMapsLink;
  final List<String> workingDays;
  final String openingTime;
  final String closingTime;
  final bool isStoreOpen;
  final String storeStatus;
  final double latitude;
  final double longitude;
  final String storeLogo;

  DataProfileModel({
    required this.id,
    required this.name,
    required this.storeDescription,
    required this.reelsCount,
    required this.carsActive,
    required this.carsSold,
    required this.handle,
    required this.phone,
    required this.monthlyReelsLimit,
    required this.contactPhone,
    required this.locationAddress,
    required this.googleMapsLink,
    required this.workingDays,
    required this.openingTime,
    required this.closingTime,
    required this.isStoreOpen,
    required this.storeStatus,
    required this.latitude,
    required this.longitude,
    required this.storeLogo,
  });

  DataProfileModel copyWith({
    int? id,
    String? name,
    String? storeDescription,
    int? reelsCount,
    int? carsActive,
    int? carsSold,
    String? handle,
    String? phone,
    int? monthlyReelsLimit,
    String? contactPhone,
    String? locationAddress,
    String? googleMapsLink,
    List<String>? workingDays,
    String? openingTime,
    String? closingTime,
    bool? isStoreOpen,
    String? storeStatus,
    double? latitude,
    double? longitude,
    String? storeLogo,
  }) {
    return DataProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storeDescription: storeDescription ?? this.storeDescription,
      reelsCount: reelsCount ?? this.reelsCount,
      carsActive: carsActive ?? this.carsActive,
      carsSold: carsSold ?? this.carsSold,
      handle: handle ?? this.handle,
      phone: phone ?? this.phone,
      monthlyReelsLimit: monthlyReelsLimit ?? this.monthlyReelsLimit,
      contactPhone: contactPhone ?? this.contactPhone,
      locationAddress: locationAddress ?? this.locationAddress,
      googleMapsLink: googleMapsLink ?? this.googleMapsLink,
      workingDays: workingDays ?? this.workingDays,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      isStoreOpen: isStoreOpen ?? this.isStoreOpen,
      storeStatus: storeStatus ?? this.storeStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      storeLogo: storeLogo ?? this.storeLogo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'storeDescription': storeDescription,
      'reelsCount': reelsCount,
      'carsActive': carsActive,
      'carsSold': carsSold,
      'handle': handle,
      'phone': phone,
      'monthlyReelsLimit': monthlyReelsLimit,
      'contactPhone': contactPhone,
      'locationAddress': locationAddress,
      'googleMapsLink': googleMapsLink,
      'workingDays': workingDays,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'isStoreOpen': isStoreOpen,
      'storeStatus': storeStatus,
      'latitude': latitude,
      'longitude': longitude,
      'storeLogo': storeLogo,
    };
  }

  factory DataProfileModel.fromMap(Map<String, dynamic> map) {
    return DataProfileModel(
      id: map['id'] as int,
      name: map['name'] as String,
      storeDescription: map['store_description'] as String,
      reelsCount: map['reels_count'] as int,
      carsActive: map['cars_active'] as int,
      carsSold: map['cars_sold'] as int,
      handle: map['handle'] as String,
      phone: map['phone'] as String,
      monthlyReelsLimit: map['monthly_reels_limit'] as int,
      contactPhone: map['contact_phone'] as String,
      locationAddress: map['location_address'] as String,
      googleMapsLink: map['google_maps_link'] as String,
      workingDays: List<String>.from(map['working_days'] as List),
      openingTime: map['opening_time'] as String,
      closingTime: map['closing_time'] as String,
      isStoreOpen: map['is_store_open'] as bool,
      storeStatus: map['store_status'] as String,
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      storeLogo: map['store_logo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DataProfileModel.fromJson(String source) =>
      DataProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
