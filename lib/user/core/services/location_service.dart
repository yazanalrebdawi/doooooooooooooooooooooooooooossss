import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' hide LocationAccuracy;
import 'package:geolocator/geolocator.dart' as geolocator show LocationAccuracy;
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../constants/app_config.dart';

class LocationService {
  static Location location = Location();

  /// Check if location permission is already granted (does NOT request permission)
  /// Use this to check existing permission status only.
  /// To request new permission, show LocationDisclosureScreen from UI code first.
  /// 
  /// [forceRefresh] - If true, will add delay, retry mechanism, and verify by actually getting location
  static Future<bool> checkLocationPermission({bool forceRefresh = false}) async {
    try {
      // If forceRefresh, wait longer and retry multiple times to ensure permission state is synced
      if (forceRefresh) {
        // Wait longer for permission state to sync after granting
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Retry up to 3 times with delays
        for (int attempt = 1; attempt <= 3; attempt++) {
          try {
            // Check with Geolocator first (since that's what we use to request permission)
            LocationPermission geolocatorPermission = await Geolocator.checkPermission();
            if (geolocatorPermission == LocationPermission.whileInUse) {
              // Verify permission actually works by trying to get location
              try {
                await Geolocator.getCurrentPosition(
                  desiredAccuracy: geolocator.LocationAccuracy.low,
                  timeLimit: const Duration(seconds: 2),
                );
                print('✅ LocationService: Permission granted and verified (checked via Geolocator, attempt $attempt)');
                return true;
              } catch (e) {
                print('⚠️ LocationService: Permission granted but location access failed: $e');
                if (attempt < 3) {
                  await Future.delayed(const Duration(milliseconds: 500));
                  continue;
                }
              }
            }
            if (geolocatorPermission == LocationPermission.deniedForever) {
              print('❌ LocationService: Permission denied forever (checked via Geolocator)');
              return false;
            }
            if (geolocatorPermission == LocationPermission.denied) {
              // If still denied, wait a bit more and retry
              if (attempt < 3) {
                print('⚠️ LocationService: Permission still denied, retrying... (attempt $attempt/3)');
                await Future.delayed(const Duration(milliseconds: 500));
                continue;
              }
              print('⚠️ LocationService: Permission denied after retries (checked via Geolocator)');
              return false;
            }
          } catch (e) {
            print('⚠️ LocationService: Error checking with Geolocator (attempt $attempt): $e');
            if (attempt < 3) {
              await Future.delayed(const Duration(milliseconds: 500));
              continue;
            }
          }
        }
      } else {
        // Normal check without retry
        try {
          // Check with Geolocator first (since that's what we use to request permission)
          LocationPermission geolocatorPermission = await Geolocator.checkPermission();
          if (geolocatorPermission == LocationPermission.whileInUse) {
            // Verify permission actually works by trying to get location
            try {
              await Geolocator.getCurrentPosition(
                desiredAccuracy: geolocator.LocationAccuracy.low,
                timeLimit: const Duration(seconds: 2),
              );
              print('✅ LocationService: Permission granted and verified (checked via Geolocator)');
              return true;
            } catch (e) {
              print('⚠️ LocationService: Permission granted but location access failed: $e');
              // Permission check failed, fall through to location package check
            }
          } else if (geolocatorPermission == LocationPermission.deniedForever) {
            print('❌ LocationService: Permission denied forever (checked via Geolocator)');
            return false;
          } else if (geolocatorPermission == LocationPermission.denied) {
            print('⚠️ LocationService: Permission denied (checked via Geolocator)');
            return false;
          } else if (geolocatorPermission == LocationPermission.always) {
            // We don't want "always" permission - it's background location
            // Reject it and fall through to location package check for consistency
            print('⚠️ LocationService: "Always" permission detected (we only want "while in use")');
            // Fall through to location package check
          } else {
            // Unknown permission status, fall through to location package check
            print('⚠️ LocationService: Unknown permission status from Geolocator: $geolocatorPermission');
            // Fall through to location package check
          }
        } catch (e) {
          print('⚠️ LocationService: Error checking with Geolocator: $e');
          // Fall through to location package check
        }
      }

      // Fallback: Check if location services are enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        print('❌ LocationService: Location services are disabled');
        return false;
      }

      // Fallback: Check location permission with location package
      PermissionStatus permission = await location.hasPermission();

      if (permission == PermissionStatus.deniedForever) {
        print('❌ LocationService: Permission denied forever');
        return false;
      }

      if (permission == PermissionStatus.granted || permission == PermissionStatus.grantedLimited) {
        print('✅ LocationService: Permission already granted');
        return true;
      }

      // Permission is denied - must show disclosure dialog first (Google Play requirement)
      print('⚠️ LocationService: Permission denied - must show disclosure dialog first');
      return false;
    } catch (e) {
      print('❌ LocationService Error checking permission: $e');
      return false;
    }
  }

  /// Check and request location service
  static Future<void> checkAndRequestLocationService() async {
    var isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        throw LocationServiceException();
      }
    }
  }

  /// Check and request location permission
  /// NOTE: This should only be called AFTER showing the prominent disclosure screen
  /// Uses permission_handler to ensure only "while in use" permission is requested
  static Future<void> checkAndRequestLocationPermission() async {
    // Use permission_handler to request ONLY "while in use" permission
    permission_handler.PermissionStatus permissionStatus = await permission_handler.Permission.locationWhenInUse.status;
    
    if (permissionStatus.isPermanentlyDenied) {
      throw LocationPermissionException();
    }
    
    if (permissionStatus.isDenied) {
      permissionStatus = await permission_handler.Permission.locationWhenInUse.request();
      if (!permissionStatus.isGranted) {
        throw LocationPermissionException();
      }
    }
  }

  /// Request location permission (should only be called after showing disclosure)
  static Future<bool> requestLocationPermission() async {
    try {
      await checkAndRequestLocationService();
      await checkAndRequestLocationPermission();
      return true;
    } catch (e) {
      print('❌ LocationService: Error requesting permission: $e');
      return false;
    }
  }

  /// Get real-time location data stream
  static void getRealTimeLocationData(void Function(LocationData)? onData) async {
    try {
      await checkAndRequestLocationService();
      await checkAndRequestLocationPermission();
      location.onLocationChanged.listen(onData);
    } catch (e) {
      print('❌ LocationService: Error getting real-time location: $e');
    }
  }

  /// Get current location (one-time)
  static Future<LocationData?> getLocation() async {
    try {
      await checkAndRequestLocationService();
      await checkAndRequestLocationPermission();
      return await location.getLocation();
    } catch (e) {
      print('❌ LocationService: Error getting location: $e');
      return null;
    }
  }

  /// Get current location and return as Position (compatible with existing code)
  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        print('❌ LocationService: Permission not granted');
        return null;
      }

      // Get location using location package
      LocationData? locationData = await getLocation();
      if (locationData == null) {
        return null;
      }

      // Convert LocationData to Position for compatibility
      return Position(
        longitude: locationData.longitude ?? 0,
        latitude: locationData.latitude ?? 0,
        timestamp: DateTime.now(),
        accuracy: locationData.accuracy ?? 0,
        altitude: locationData.altitude ?? 0,
        altitudeAccuracy: 0,
        heading: locationData.heading ?? 0,
        speed: locationData.speed ?? 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
      );
    } catch (e) {
      print('❌ LocationService Error getting location: $e');
      return null;
    }
  }

  static Future<double> calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      // First try to get route distance using Google Directions API
      final routeDistance = await _getRouteDistance(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      if (routeDistance > 0) {
        return routeDistance;
      }

      // Fallback to straight line distance
      double distanceInMeters = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      return distanceInMeters;
    } catch (e) {
      print('Error calculating distance: $e');
      return 0.0;
    }
  }

  // Get route distance using Google Directions API
  static Future<double> _getRouteDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      // Use Google Directions API to get real road distance
      final url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$startLatitude,$startLongitude&'
          'destination=$endLatitude,$endLongitude&'
          'key=${AppConfig.googleMapsApiKey}';

      print('🗺️ Requesting route from Google Directions API...');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final status = data['status'] as String?;

        // Handle API errors gracefully - calculate fallback distance immediately
        if (status == 'REQUEST_DENIED' || status == 'OVER_QUERY_LIMIT' || status == 'INVALID_REQUEST') {
          print('⚠️ Google Directions API not available (${status}), calculating straight-line distance');
          // Calculate and return fallback straight-line distance
          final fallbackDistance = Geolocator.distanceBetween(
            startLatitude,
            startLongitude,
            endLatitude,
            endLongitude,
          );
          print('📏 Fallback straight-line distance: ${fallbackDistance}m');
          return fallbackDistance;
        }

        if (status == 'OK' && data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final legs = route['legs'];

          if (legs != null && (legs as List).isNotEmpty) {
            final distance = legs[0]['distance']['value']; // Distance in meters
            print('✅ Real road distance: ${distance}m');
            return distance.toDouble();
          }
        } else {
          print('⚠️ Google Directions API error: ${status ?? 'Unknown'}');
        }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
      }

      // Calculate and return fallback straight-line distance
      print('⚠️ Google Directions API failed, calculating straight-line distance');
      final fallbackDistance = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
      print('📏 Fallback straight-line distance: ${fallbackDistance}m');
      return fallbackDistance;
    } catch (e) {
      print('⚠️ Error getting route distance: $e');
      // Calculate and return fallback straight-line distance
      final fallbackDistance = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
      print('📏 Fallback straight-line distance: ${fallbackDistance}m');
      return fallbackDistance;
    }
  }

  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  // Fallback location for UAE (Dubai coordinates)
  static Position getDefaultLocation() {
    return Position(
      longitude: 55.2708,
      latitude: 25.2048,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  // Get location with fallback
  static Future<Position> getLocationWithFallback() async {
    try {
      final position = await getCurrentLocation();
      if (position != null) {
        return position;
      } else {
        print('🔄 LocationService: Using fallback location (Dubai)');
        return getDefaultLocation();
      }
    } catch (e) {
      print(
          '🔄 LocationService: Error occurred, using fallback location (Dubai)');
      return getDefaultLocation();
    }
  }
}

class LocationServiceException implements Exception {}

class LocationPermissionException implements Exception {}
