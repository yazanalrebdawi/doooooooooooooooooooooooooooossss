import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfoService {
  Future<bool> get isConnected;
  Future<List<ConnectivityResult>> get connectionTypes;
  Stream<List<ConnectivityResult>> get onConnectionChange;
  Future<bool> get isWifi;
  Future<bool> get isMobile;
}
