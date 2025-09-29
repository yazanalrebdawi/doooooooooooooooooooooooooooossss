import 'package:dooss_business_app/core/network/api.dart';
import 'package:dooss_business_app/core/network/api_request.dart';
import 'package:dooss_business_app/core/network/api_urls.dart';
import 'package:dooss_business_app/features/home/data/models/service_model.dart';
import 'service_remote_data_source.dart';

class ServiceRemoteDataSourceImp implements ServiceRemoteDataSource {
  final API api;
  ServiceRemoteDataSourceImp({required this.api});

  @override
  Future<List<ServiceModel>> fetchServices() async {
    // This method should not be used anymore, use fetchNearbyServices instead
    throw Exception('Use fetchNearbyServices with location parameters instead');
  }

  @override
  Future<List<ServiceModel>> fetchNearbyServices({
    required double lat,
    required double lon,
    String? type,
    int radius = 5000,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      print('Fetching nearby services from API...');
      
      String url = '${ApiUrls.servicesNearby}?lat=$lat&lon=$lon&radius=$radius&limit=$limit&offset=$offset';
      if (type != null) {
        url += '&type=$type';
      }
      
      final response = await api.get(
        apiRequest: ApiRequest(url: url),
      );
      print('Nearby services API response: $response');
      return response.fold(
        (failure) {
          print('API Failure: ${failure.message}');
          throw Exception(failure.message);
        },
        (data) {
          print('Nearby services data received: $data');
          print('Data type: ${data.runtimeType}');
          print('Data length: ${data is List ? data.length : 'Not a list'}');
          
          if (data is List) {
            if (data.isEmpty) {
              print('⚠️ API returned empty list - no services found for this location');
              print('🔍 Debug Info:');
              print('   - URL: $url');
              print('   - Lat: $lat, Lon: $lon, Radius: $radius');
              print('   - Type: $type');
              print('   - Response: $data');
              return [];
            }
            print('📋 Processing ${data.length} services...');
            final services = data.map((e) {
              print('Processing service: $e');
              return ServiceModel.fromJson(e);
            }).toList();
            print('✅ Successfully processed ${services.length} services');
            return services;
          } else {
            print('❌ Invalid data format - expected List but got ${data.runtimeType}');
            print('🔍 Debug Info:');
            print('   - URL: $url');
            print('   - Response: $data');
            throw Exception('Invalid data format received from API');
          }
        },
      );
    } catch (e) {
      print('ServiceRemoteDataSource fetchNearbyServices error: $e');
      rethrow;
    }
  }

  @override
  Future<ServiceModel> fetchServiceDetails(int serviceId) async {
    try {
      print('Fetching service details for ID: $serviceId');
      final response = await api.get(
        apiRequest: ApiRequest(url: '${ApiUrls.serviceDetails}$serviceId/'),
      );
      print('Service details API response: $response');
      return response.fold(
        (failure) {
          print('Failure: ${failure.message}');
          throw Exception(failure.message);
        },
        (data) {
          print('Service details data received: $data');
          if (data is Map<String, dynamic>) {
            return ServiceModel.fromJson(data);
          } else {
            throw Exception('Invalid data format received from API');
          }
        },
      );
    } catch (e) {
      print('ServiceRemoteDataSource fetchServiceDetails error: $e');
      rethrow;
    }
  }

  @override
  Future<List<ServiceModel>> fetchServicesByCategory(String category) async {
    // This method should be used with location parameters
    throw Exception('Use fetchNearbyServices with location and category parameters instead');
  }
}
