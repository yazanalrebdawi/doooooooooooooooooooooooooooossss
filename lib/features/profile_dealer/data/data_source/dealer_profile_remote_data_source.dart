import 'package:dartz/dartz.dart';
import '../../../../core/network/app_dio.dart';
import '../../../../core/network/api_urls.dart';
import '../../../../core/network/failure.dart';
import '../models/dealer_model.dart';
import '../models/reel_model.dart';
import '../models/service_model.dart';
import '../../../home/data/models/car_model.dart';

abstract class DealerProfileRemoteDataSource {
  Future<Either<Failure, DealerModel>> fetchDealerProfile(String dealerId);
  Future<Either<Failure, List<ReelModel>>> fetchReels(String dealerId);
  Future<Either<Failure, List<CarModel>>> fetchCars(String dealerId);
  Future<Either<Failure, List<ServiceModel>>> fetchServices(String dealerId);
  Future<Either<Failure, bool>> toggleFollow(String dealerId);
}

class DealerProfileRemoteDataSourceImpl implements DealerProfileRemoteDataSource {
  final AppDio _dio;

  DealerProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<Failure, DealerModel>> fetchDealerProfile(String dealerId) async {
    try {
      print('🔍 Fetching dealer profile for ID: $dealerId');
      final url = ApiUrls.dealerProfileWithId.replaceAll('{id}', dealerId);
      final response = await _dio.dio.get(url);
      
      print('✅ Dealer profile response: ${response.data}');
      
      if (response.statusCode == 200) {
        final dealer = DealerModel.fromJson(response.data);
        return Right(dealer);
      } else {
        return Left(Failure(message: 'Failed to fetch dealer profile'));
      }
    } catch (e) {
      print('❌ DealerProfileRemoteDataSource error: $e');
      
      // معالجة خاصة لخطأ الـ authentication
      if (e.toString().contains('401') || e.toString().contains('Authentication')) {
        return Left(Failure(message: 'Authentication credentials were not provided.'));
      }
      
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReelModel>>> fetchReels(String dealerId) async {
    try {
      print('🔍 Fetching reels for dealer ID: $dealerId');
      final url = ApiUrls.dealerReels.replaceAll('{id}', dealerId);
      final response = await _dio.dio.get(url);
      
      print('✅ Reels response: ${response.data}');
      
      if (response.statusCode == 200) {
                 try {
           final List<dynamic> reelsData = response.data['results'] ?? response.data;
           print('🔍 Parsing ${reelsData.length} reels...');
           
           final reels = <ReelModel>[];
           for (int i = 0; i < reelsData.length; i++) {
             try {
               final json = reelsData[i];
               print('🔍 Parsing reel $i: $json');
               final reel = ReelModel.fromJson(json);
               reels.add(reel);
             } catch (e) {
               print('⚠️ Error parsing reel $i: ${reelsData[i]}, error: $e');
               // إرجاع reel فارغ في حالة الخطأ
               try {
                 final json = reelsData[i];
                 final fallbackReel = ReelModel(
                   id: json['id']?.toString() ?? '0',
                   title: json['title']?.toString() ?? 'Unknown',
                   description: json['description']?.toString(),
                   thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
                   videoUrl: json['video_url']?.toString() ?? '',
                   viewsCount: 0,
                   likesCount: 0,
                   dealerId: json['dealer_id']?.toString() ?? '0',
                   createdAt: DateTime.now(),
                 );
                 reels.add(fallbackReel);
               } catch (fallbackError) {
                 print('❌ Even fallback reel creation failed: $fallbackError');
                 
                 reels.add(ReelModel(
                   id: '0',
                   title: 'Unknown',
                   description: null,
                   thumbnailUrl: '',
                   videoUrl: '',
                   viewsCount: 0,
                   likesCount: 0,
                   dealerId: '0',
                   createdAt: DateTime.now(),
                 ));
               }
             }
           }
           return Right(reels);
         } catch (e) {
           print('❌ Error parsing reels data: $e');
           return Left(Failure(message: 'Error parsing reels data: $e'));
         }
      } else {
        return Left(Failure(message: 'Failed to fetch reels'));
      }
    } catch (e) {
      print('❌ DealerProfileRemoteDataSource reels error: $e');
      
      // معالجة خاصة لخطأ الـ authentication
      if (e.toString().contains('401') || e.toString().contains('Authentication')) {
        return Left(Failure(message: 'Authentication credentials were not provided.'));
      }
      
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarModel>>> fetchCars(String dealerId) async {
    try {
      print('🔍 Fetching cars for dealer ID: $dealerId');
      final url = ApiUrls.dealerCars.replaceAll('{id}', dealerId);
      final response = await _dio.dio.get(url);
      
      print('✅ Cars response: ${response.data}');
      
      if (response.statusCode == 200) {
                 try {
           final List<dynamic> carsData = response.data['results'] ?? response.data;
           print('🔍 Parsing ${carsData.length} cars...');
           
           final cars = <CarModel>[];
           for (int i = 0; i < carsData.length; i++) {
             try {
               final json = carsData[i];
               print('🔍 Parsing car $i: $json');
               final car = CarModel.fromJson(json);
               cars.add(car);
             } catch (e) {
               print('⚠️ Error parsing car $i: ${carsData[i]}, error: $e');
               // إرجاع car فارغ في حالة الخطأ
               try {
                 final json = carsData[i];
                 final fallbackCar = CarModel(
                   id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
                   name: json['name']?.toString() ?? 'Unknown Car',
                   imageUrl: json['image_url']?.toString() ?? '',
                   price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
                   isNew: json['is_new'] ?? false,
                   location: json['location']?.toString() ?? '',
                   mileage: json['mileage']?.toString() ?? '',
                   year: int.tryParse(json['year']?.toString() ?? '0') ?? 0,
                   transmission: json['transmission']?.toString() ?? '',
                   engine: json['engine']?.toString() ?? '',
                   fuelType: json['fuel_type']?.toString() ?? '',
                   color: json['color']?.toString() ?? '',
                   doors: int.tryParse(json['doors']?.toString() ?? '0') ?? 0,
                   sellerNotes: json['seller_notes']?.toString() ?? '',
                   sellerName: json['seller_name']?.toString() ?? '',
                   sellerType: json['seller_type']?.toString() ?? '',
                   sellerImage: json['seller_image']?.toString() ?? '',
                   dealerId: int.tryParse(json['dealer_id']?.toString() ?? '0') ?? 0,
                 );
                 cars.add(fallbackCar);
               } catch (fallbackError) {
                 print('❌ Even fallback car creation failed: $fallbackError');
                 
                 cars.add(CarModel(
                   id: 0,
                   name: 'Unknown Car',
                   imageUrl: '',
                   price: 0.0,
                   isNew: false,
                   location: '',
                   mileage: '',
                   year: 0,
                   transmission: '',
                   engine: '',
                   fuelType: '',
                   color: '',
                   doors: 0,
                   sellerNotes: '',
                   sellerName: '',
                   sellerType: '',
                   sellerImage: '',
                   dealerId: 0,
                 ));
               }
             }
           }
           return Right(cars);
         } catch (e) {
           print('❌ Error parsing cars data: $e');
           return Left(Failure(message: 'Error parsing cars data: $e'));
         }
      } else {
        return Left(Failure(message: 'Failed to fetch cars'));
      }
    } catch (e) {
      print('❌ DealerProfileRemoteDataSource cars error: $e');
      
      // معالجة خاصة لخطأ الـ authentication
      if (e.toString().contains('401') || e.toString().contains('Authentication')) {
        return Left(Failure(message: 'Authentication credentials were not provided.'));
      }
      
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceModel>>> fetchServices(String dealerId) async {
    try {
      print('🔍 Fetching services for dealer ID: $dealerId');
      final url = ApiUrls.dealerServices.replaceAll('{id}', dealerId);
      final response = await _dio.dio.get(url);
      
      print('✅ Services response: ${response.data}');
      
      if (response.statusCode == 200) {
                 try {
           final List<dynamic> servicesData = response.data['results'] ?? response.data;
           print('🔍 Parsing ${servicesData.length} services...');
           
           final services = <ServiceModel>[];
           for (int i = 0; i < servicesData.length; i++) {
             try {
               final json = servicesData[i];
               print('🔍 Parsing service $i: $json');
               final service = ServiceModel.fromJson(json);
               services.add(service);
             } catch (e) {
               print('⚠️ Error parsing service $i: ${servicesData[i]}, error: $e');
               // إرجاع service فارغ في حالة الخطأ
               try {
                 final json = servicesData[i];
                 final fallbackService = ServiceModel(
                   id: json['id']?.toString() ?? '0',
                   name: json['name']?.toString() ?? 'Unknown Service',
                   description: json['description']?.toString() ?? '',
                   location: json['location']?.toString() ?? '',
                   status: json['status']?.toString() ?? 'Closed',
                   rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
                   category: json['category']?.toString() ?? '',
                   categoryColor: json['category_color']?.toString() ?? '#4CAF50',
                   iconColor: json['icon_color']?.toString() ?? '#4CAF50',
                   dealerId: json['dealer_id']?.toString() ?? '0',
                   phoneNumber: json['phone_number']?.toString() ?? '',
                 );
                 services.add(fallbackService);
               } catch (fallbackError) {
                 print('❌ Even fallback service creation failed: $fallbackError');
                 
                 services.add(ServiceModel(
                   id: '0',
                   name: 'Unknown Service',
                   description: '',
                   location: '',
                   status: 'Closed',
                   rating: 0.0,
                   category: '',
                   categoryColor: '#4CAF50',
                   iconColor: '#4CAF50',
                   dealerId: '0',
                   phoneNumber: '',
                 ));
               }
             }
           }
           return Right(services);
         } catch (e) {
           print('❌ Error parsing services data: $e');
           return Left(Failure(message: 'Error parsing services data: $e'));
         }
      } else {
        return Left(Failure(message: 'Failed to fetch services'));
      }
    } catch (e) {
      print('❌ DealerProfileRemoteDataSource services error: $e');
      
      // معالجة خاصة لخطأ الـ authentication
      if (e.toString().contains('401') || e.toString().contains('Authentication')) {
        return Left(Failure(message: 'Authentication credentials were not provided.'));
      }
      
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFollow(String dealerId) async {
    try {
      print('🔍 Toggling follow for dealer ID: $dealerId');
      final url = ApiUrls.dealerFollow.replaceAll('{id}', dealerId);
      final response = await _dio.dio.post(url);
      
      print('✅ Toggle follow response: ${response.data}');
      
      if (response.statusCode == 200) {
        return Right(response.data['is_following'] ?? false);
      } else {
        return Left(Failure(message: 'Failed to toggle follow'));
      }
    } catch (e) {
      print('❌ DealerProfileRemoteDataSource toggle follow error: $e');
      
      // معالجة خاصة لخطأ الـ authentication
      if (e.toString().contains('401') || e.toString().contains('Authentication')) {
        return Left(Failure(message: 'Authentication credentials were not provided.'));
      }
      
      return Left(Failure(message: e.toString()));
    }
  }
}
