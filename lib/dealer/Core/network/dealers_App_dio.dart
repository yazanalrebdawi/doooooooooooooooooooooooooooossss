// import 'package:dio/dio.dart';

// class DealersAppDio {
//   // 1️⃣ Private static instance
//   static final DealersAppDio _instance = DealersAppDio._internal();

//   // 2️⃣ Dio instance
//   final Dio dio = Dio();

//   // 3️⃣ Private named constructor
//   DealersAppDio._internal() {
//     dio.options.headers = {
// 'Content-Type': 'application/json',
//     };
//   }

//   // 4️⃣ Public factory constructor to return the same instance
//   factory DealersAppDio() {
//     return _instance;
//   }

//   // 5️⃣ Method to update token dynamically
//   void addToken(String token) {
//     dio.options.headers['Authorization'] = 'Bearer $token';
//   }
// }
