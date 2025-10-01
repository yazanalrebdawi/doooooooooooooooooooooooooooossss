// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dooss_business_app/dealer/Core/network/Base_Url.dart';
import 'package:dooss_business_app/dealer/Core/network/failure.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/dashboard_info_model.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/data_profile_models.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/product_data_model.dart';
import 'package:image_picker/image_picker.dart';

class RemouteDealerDataSource {
  var header = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzYxMTIyMzE5LCJpYXQiOjE3NTg1MzAzMTksImp0aSI6IjVmMzljYzkyOTRjMTQ0YzdiNDk1OTMwODc4NWE0OTIwIiwidXNlcl9pZCI6IjMifQ.XIHFtjThZGYEbPDXRZZB41bw9q0Yrqd1uL-g723gg1A',
  };
  Dio dio = Dio();
  Future<Either<Failure, List<productdata>>> getDataProduct() async {
    try {
      // var url = Uri.parse('http://localhost:8010/api/products/');
      var response = await dio.get(
        'http://10.0.2.2:8010/api/products/',
        options: Options(headers: header),
      );
      List<productdata> responsedata = (response.data as List).map((item) {
        return productdata.fromMap(item);
      }).toList();
      print(responsedata.length);
      return right(responsedata);
    } catch (e) {
      return left(Failure.handleExcaption(e));
    }
  }

  Future<Either<String, productdata>> addProduct(
    String nameProduct,
    String description,
    String price,
    String category,
    String discount,
    XFile image,
  ) async {
    var url = Uri.parse('http://10.0.2.2:8010/api/products/');
    // var body = {
    //   "name": nameProduct,
    //   "description": description,
    //   "price": price,
    //   "discount": discount,
    //   "stock": 5,
    //   "condition": "new",
    //   "category": category,
    //   "material": "ABS Plastic",
    //   "color": "Red/Clear",
    //   "warranty": "12 months manufacturer warranty",
    //   "installation_info":
    //       "Direct replacement. Professional installation recommended.",
    // };

    var dat1a = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: image.path),
      'name': nameProduct,
      'description': description,
      'price': price,
      'discount': discount,
      'stock': '5',
      'condition': 'new',
      'category': category,
    });

    try {
      var response = await dio.post(
        'http://10.0.2.2:8010/api/products/',
        data: dat1a,
        options: Options(headers: header),
      );
      productdata data = productdata(
        id: response.data['id'],
        name: response.data['name'],
        price: response.data['price'],
        discount: response.data['discount'],
        finalPrice: response.data['final_price'],
        mainImage: response.data['images'],
        category: response.data['category'],
        isAvailable: true,
      );
      // ResponseDataProduct data = ResponseDataProduct.fromMap(response.data);
      print(data.mainImage);
      return right(data);
    } catch (error) {
      print(error.toString());
      return left(error.toString());
    }
  }

  Future<Either<String, void>> deleteProduct(int id) async {
    try {
      var response = await dio.delete(
        'http://10.0.2.2:8010/api/products/$id/',
        options: Options(headers: header),
      );
      if (response.statusCode == 204) {
        print('okey');
        return right(null);
      } else {
        return left('feiler delete');
      }
    } catch (error) {
      print(error.toString());
      return left(error.toString());
    }
  }

  Future<Either<Failure, void>> editAvailabilityProduct(
    int id,
    bool currentValue,
  ) async {
    var url = '${AppUrl.BaseUrl}/dealers/products/$id/availability/';
    var data = {"available": currentValue};
    try {
      var response = await dio.patch(
        url,
        options: Options(headers: header),
        data: data,
      );
      if (response.statusCode == 200) {
        print('okey!');
        return right(null);
      } else {
        return left(
          Failure.handleExcaption(Failure(massageError: 'Error Editing')),
        );
      }
    } catch (error) {
      print(error.toString());
      return left(Failure.handleExcaption(error));
    }
  }

  Future<Either<Failure, DealerDashboardInfo>> getDataDashboard() async {
    var url = 'http://localhost:8010/dealers/dashboard/';
    try {
      var response = await dio.get(url, options: Options(headers: header));
      print(response.data);
      DealerDashboardInfo data = DealerDashboardInfo.fromMap(response.data);
      return right(data);
    } catch (e) {
      return left(Failure.handleExcaption(e));
    }
  }

  Future<Either<Failure, Car>> AddCars(
    String brand,
    String year,
    String Model,
    String price,
    String milleage,
    String engineSize,
    String typeFuel,
    String Transmissiion,
    String Drivetrain,
    int Door,
    int seats,
    XFile image,
  ) async {
    var deta = {
      "name": "M5",
      "brand": brand,
      "model": Model,
      "price": price,
      "year": 2023,
      "kilometers": milleage,
      "fuel_type": typeFuel,
      "transmission": Transmissiion,
      "engine_capacity": engineSize, //////
      "drive_type": Drivetrain,
      "color": "White",
      "doors_count": Door,
      "seats_count": seats,
      "status": "new",
      "license_status": "licensed",
      "discount": "0.00",
      "lat": 33.514,
      "lon": 36.276,
    };

    var data = FormData.fromMap({
      'image': [
        await MultipartFile.fromFile(image.path, filename: image.name),
        // await MultipartFile.fromFile(
        //   '/C:/Users/ASUS/Pictures/Screenshots/لقطة شاشة 2025-09-21 073214.png',
        //   filename:
        //       '/C:/Users/ASUS/Pictures/Screenshots/لقطة شاشة 2025-09-21 073214.png',
        // ),
      ],
      'name': 'Model S',
      'brand': brand,
      'model': Model,
      'price': price,
      'discount': 0,
      'year': year,
      'kilometers': milleage,
      'fuel_type': typeFuel,
      'transmission': Transmissiion,
      'engine_capacity': engineSize,
      'drive_type': Drivetrain,
      'color': 'White',
      'is_available': 'true',
      'doors_count': Door,
      'seats_count': seats,
      'status': 'new',
      'license_status': 'licensed',
      'lat': '25.2048',
      'lon': '55.2708',
      'is_main': 'true',
    });

    var url = 'http://10.0.2.2:8010/cars/';
    try {
      var response = await dio.post(
        url,
        options: Options(headers: header),
        data: data,
      );
      Car addedDataCar = Car.fromJson(response.data);

      print(response.data);
      return right(addedDataCar);
    } catch (error) {
      print(error.toString());
      return left(Failure.handleExcaption(error));
    }
  }

  Future<Either<Failure, bool>> editproductData(
    int id,
    String name,
    String price,
    String discount,
    bool isAvailable,
    String Category,
    XFile? image,
  ) async {
    // var url = '${AppUrl.BaseUrl}/products/$id/';
    print(image!.path);
    var data = FormData.fromMap({
      // 'main_image': [
      //   await MultipartFile.fromFile(
      //     '/C:/Users/ASUS/Pictures/Screenshots/لقطة شاشة 2025-09-22 004622.png',
      //     filename:
      //         '/C:/Users/ASUS/Pictures/Screenshots/لقطة شاشة 2025-09-22 004622.png',
      //   ),
      // ],
      'name': name,
      'price': price,
      'discount': discount,
      'is_available': true,
      'category': Category,
    });
    if (image != null) {
      data.files.add(
        MapEntry(
          'main_image',
          await MultipartFile.fromFile(image.path, filename: "profile.jpg"),
        ),
      );
    }
    print(data.fields);
    try {
      var response = await dio.patch(
        'http://10.0.2.2:8010/api/products/$id/',
        data: data,
        options: Options(headers: header),
      );
      // dataresponseEditProduct editProduct = dataresponseEditProduct.fromMap(
      //   response.data,
      // );
      print(response.data);
      return right(true);
    } catch (error) {
      print(error);
      // if (error is DioException) {
      //   print(error.response!.statusMessage);
      // }
      return left(Failure.handleExcaption(error));
    }
  }

  Future<Either<Failure, DataProfileModel>> getDataStoreProfile() async {
    var url = 'http://10.0.2.2:8010/api/dealers/me/profile/';
    try {
      var response = await dio.get(url, options: Options(headers: header));
      print(response.data);
      DataProfileModel responseData = DataProfileModel.fromMap(response.data);
      return right(responseData);
    } catch (e) {
      print(e.toString());
      return left(Failure.handleExcaption(e));
    }
  }

  Future<Either<Failure, DataProfileModel>> editDataProfile(
    String name,
    String description,
    String phone,
    String closeTime,
    String OpenTime,
    String lat,
    String lot,
    List<String> day,
  ) async {
    print(lat);
    var url = 'http://10.0.2.2:8010/api/dealers/me/profile/';
    print('------------');
    print(OpenTime.runtimeType);
    var data = FormData.fromMap({
      'bio': 'agent',
      'name': name,
      // 'working_days': 'monday',
      'store_description': description,
      'phone': phone,
      'opening_time': '${OpenTime}',
      'closing_time': '${closeTime}',
      'latitude': '${lat}',
      'longitude': lot,
    });
    for (String item in day) {
      data.fields.add(MapEntry('working_days', item));
    }
    print(data.fields);
    try {
      var response = await dio.request(
        url,
        options: Options(method: 'PATCH', headers: header),
        data: data,
      );
      DataProfileModel responsedata = DataProfileModel.fromMap(response.data);
      print(response.data);
      return right(responsedata);
    } catch (e) {
      print(e.toString());
      return left(Failure.handleExcaption(e));
    }
  }
}

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
