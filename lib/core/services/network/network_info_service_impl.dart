import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dooss_business_app/core/services/network/network_info_service.dart';

class NetworkInfoServiceImpl implements NetworkInfoService {
  final Connectivity connectivity;
  NetworkInfoServiceImpl(this.connectivity);

  //?--------------------------------------------------------
  //* بترجع نوع الاتصال الحالي (ممكن يكون أكثر من واحد)
  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }
  //?--------------------------------------------------------

  //* ارجاع نوع الاتصال
  @override
  Future<List<ConnectivityResult>> get connectionTypes async {
    return await connectivity.checkConnectivity();
  }
  //?--------------------------------------------------------

  //* متابعة تغييرات الاتصال بشكل لحظي (ممكن يكون أكثر من نوع بنفس الوقت)
  @override
  Stream<List<ConnectivityResult>> get onConnectionChange {
    return connectivity.onConnectivityChanged;
  }
  //?--------------------------------------------------------

  //* هل الجهاز متصل عبر WiFi
  @override
  Future<bool> get isWifi async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }
  //?--------------------------------------------------------

  //* هل الجهاز متصل عبر بيانات الموبايل
  @override
  Future<bool> get isMobile async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }
  //?--------------------------------------------------------
}
