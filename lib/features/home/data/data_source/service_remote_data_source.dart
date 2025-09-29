import 'package:dooss_business_app/features/home/data/models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> fetchServices();
  Future<List<ServiceModel>> fetchNearbyServices({
    required double lat,
    required double lon,
    String? type,
    int radius = 5000,
    int limit = 10,
    int offset = 0,
  });
  Future<ServiceModel> fetchServiceDetails(int serviceId);
  Future<List<ServiceModel>> fetchServicesByCategory(String category);
}
