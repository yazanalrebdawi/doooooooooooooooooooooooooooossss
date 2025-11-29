import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../../../user/core/constants/app_config.dart';

// class GoogleMap extends StatefulWidget {
//   const GoogleMap({super.key});

//   @override
//   State<GoogleMap> createState() => _GoogleMapState();
// }

// class _GoogleMapState extends State<GoogleMap> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterLocationPicker(
//         // initZoom: 11,
//         // minZoomLevel: 5,
//         // maxZoomLevel: 16,
//         trackMyPosition: true,
//         searchBarBackgroundColor: Colors.white,
//         selectedLocationButtonTextStyle: const TextStyle(fontSize: 18),
//         mapLanguage: 'en',
//         onError: (e) => print(e),
//         selectLocationButtonLeadingIcon: const Icon(Icons.check),
//         userAgent: 'MyApp/1.0.0 (contact@m_code.com)',
//         onPicked: (pickedData) {
//           // print(pickedData.latLong.latitude);
//           // print(pickedData.latLong.longitude);
//           // print(pickedData.address);
//           // print(pickedData.addressData);
//         },
//         onChanged: (pickedData) {
//           print(pickedData.latLong.latitude);
//           print(pickedData.latLong.longitude);
//           print(pickedData.address);
//           print(pickedData.addressData);
//         },
//         // showContributorBadgeForOSM: true,
//       ),
//     );
//   }
// }

// class UserLocationMap extends StatefulWidget {
//   const UserLocationMap({Key? key}) : super(key: key);

//   @override
//   State<UserLocationMap> createState() => _UserLocationMapState();
// }

// class _UserLocationMapState extends State<UserLocationMap> {
//   GoogleMapController? _mapController;
//   LatLng? _userLatLng;
//   String _status = "جاري تحديد الموقع...";

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() => _status = "خدمة الموقع غير مفعلة");
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() => _status = "تم رفض صلاحية الموقع");
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() => _status = "تم رفض الصلاحية دائمًا من الإعدادات");
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _userLatLng = LatLng(position.latitude, position.longitude);
//       _status = "تم تحديد الموقع";
//     });

//     // تحريك الكاميرا إلى موقع المستخدم
//     _mapController?.animateCamera(
//       CameraUpdate.newLatLngZoom(_userLatLng!, 16),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("موقعي على الخريطة")),
//       body: _userLatLng == null
//           ? Center(child: Text(_status))
//           : GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _userLatLng!,
//                 zoom: 16,
//               ),
//               myLocationEnabled: true,      // 🔹 زر تحديد موقعي
//               myLocationButtonEnabled: true,
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("currentLocation"),
//                   position: _userLatLng!,
//                   infoWindow: const InfoWindow(title: "موقعي الحالي"),
//                 ),
//               },
//               onMapCreated: (controller) => _mapController = controller,
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.my_location),
//         onPressed: _determinePosition,
//       ),
//     );
//   }
// }

// class FlutterMapPicker extends StatefulWidget {
//   const FlutterMapPicker({Key? key}) : super(key: key);

//   @override
//   State<FlutterMapPicker> createState() => _FlutterMapPickerState();
// }

// class _FlutterMapPickerState extends State<FlutterMapPicker> {
//   LatLng? selectedPoint;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("اختر موقعك")),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: LatLng(24.7136, 46.6753), // ✅ استعمل initialCenter
//           initialZoom: 13, // ✅ استعمل initialZoom
//           onTap: (tapPos, latlng) {
//             setState(() {
//               selectedPoint = latlng;
//             });
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate:
//                 "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=YOUR_TOKEN",
//             additionalOptions: {
//               'accessToken': 'YOUR_TOKEN',
//               'id': 'mapbox/streets-v11',
//             },
//           ),

//           if (selectedPoint != null)
//             // ✅ في v8 MarkerLayer أصبح بهذا الشكل
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: selectedPoint!,
//                   width: 50,
//                   height: 50,
//                   child: const Icon(
//                     Icons.location_pin,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('OpenStreetMap مع Marker')),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: LatLng(31.9539, 35.9106),
//           initialZoom: 13.0,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: LatLng(31.9539, 35.9106),
//                 width: 40,
//                 height: 40,
//                 child: Icon(Icons.location_on, color: Colors.red, size: 40),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final MapController mapController = MapController();

//   final LatLng markerLocation = LatLng(31.9539, 35.9106);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تحديد الموقع حسب Marker')),
//       body: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           initialCenter: markerLocation, // مركز الخريطة عند البداية
//           initialZoom: 12.0,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: markerLocation,
//                 width: 40,
//                 height: 40,
//                 child: Icon(Icons.location_on, color: Colors.red, size: 40),
//               ),
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.my_location),
//         onPressed: () {
//           // تحريك الخريطة إلى Marker عند الضغط على الزر
//           mapController.move(markerLocation, 15.0);
//         },
//       ),
//     );
//   }
// }

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.lon, required this.lat});
  final Function(String value) lon;
  final Function(String value) lat;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();

  // موقع الـ Marker الحالي (يبدأ بموقع افتراضي)
  LatLng markerLocation = LatLng(
    33.5138,
    36.2765,
  ); //         LatLng(31.9539, 35.9106)
  Future<String> getCityName(
    double latitude,
    double longitude,
    dynamic placemarks,
  ) async {
    try {
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   latitude,
      //   longitude,
      //   localeIdentifier: "ar", // ar = عربي | en = إنجليزي
      // );

      if (placemarks.isNotEmpty) {
        // locality = اسم المدينة
        return placemarks.first.locality ?? "a city is unknow";
      } else {
        return "no data";
      }
    } catch (e) {
      return "failure: $e";
    }
  }

  /// Get address from coordinates using reverse geocoding
  Future<String?> _getAddressFromCoordinates(double lat, double lon) async {
    try {
      final url = '${AppConfig.googleMapsGeocodeUrl}?latlng=$lat,$lon&key=${AppConfig.googleMapsApiKey}';
      
      print('🗺️ MapScreen: Getting address for coordinates: $lat, $lon');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          // Get the formatted address from the first result
          final formattedAddress = data['results'][0]['formatted_address'] as String;
          print('✅ MapScreen: Got address: $formattedAddress');
          return formattedAddress;
        } else {
          print('⚠️ MapScreen: No address found for coordinates');
          return null; // Return null instead of coordinates
        }
      } else {
        print('❌ MapScreen: Reverse geocoding failed: ${response.statusCode}');
        return null; // Return null instead of coordinates
      }
    } catch (e) {
      print('❌ MapScreen: Error in reverse geocoding: $e');
      return null; // Return null instead of coordinates
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('select location')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: markerLocation,
          initialZoom: 12.0,
          onTap: (tapPosition, LatLng latlng) {
            setState(() {
              // تغيير موقع الـ Marker إلى النقطة التي اختارها المستخدم
              markerLocation = latlng;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: markerLocation,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          // Update lat/lon callbacks
          widget.lat(markerLocation.latitude.toString());
          widget.lon(markerLocation.longitude.toString());
          
          // Get address from coordinates (reverse geocoding)
          try {
            final address = await _getAddressFromCoordinates(
              markerLocation.latitude,
              markerLocation.longitude,
            );
            
            // Return the address to the previous screen (only if we got a valid address)
            if (mounted) {
              if (address != null && address.isNotEmpty) {
                Navigator.pop(context, address);
              } else {
                // If no address found, return null so the UI doesn't update
                Navigator.pop(context, null);
              }
            }
          } catch (e) {
            print('❌ Error getting address: $e');
            // Return null if geocoding fails
            if (mounted) {
              Navigator.pop(context, null);
            }
          }
        },
      ),
    );
  }
}
// class MyMapPage extends StatefulWidget {
//   const MyMapPage({Key? key}) : super(key: key);

//   @override
//   State<MyMapPage> createState() => _MyMapPageState();
// }

// class _MyMapPageState extends State<MyMapPage> {
//   GoogleMapController? _mapController;
//   LatLng _initialPosition = const LatLng(24.7136, 46.6753); // الرياض كنقطة بداية
//   Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // 🔑 الحصول على موقع المستخدم
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // التأكد من تفعيل GPS
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;

//     // طلب إذن
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }

//     // الحصول على الموقع
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _initialPosition = LatLng(position.latitude, position.longitude);
//       _markers.add(Marker(
//         markerId: const MarkerId('current'),
//         position: _initialPosition,
//         infoWindow: const InfoWindow(title: 'موقعي الحالي'),
//       ));
//     });

//     // تحريك الكاميرا
//     _mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: _initialPosition, zoom: 15),
//       ),
//     );
//   }

//   // إضافة Marker عند الضغط على الخريطة
//   void _onMapTapped(LatLng pos) {
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId(pos.toString()),
//           position: pos,
//           infoWindow: const InfoWindow(title: 'Marker جديد'),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Google Map Advanced')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 10),
//         onMapCreated: (controller) => _mapController = controller,
//         markers: _markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         onTap: _onMapTapped,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getCurrentLocation,
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
// }
