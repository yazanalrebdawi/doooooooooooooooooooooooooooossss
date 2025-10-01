import 'package:dio/dio.dart';

class AppDio {
  Dio _dio;
  Dio get dio => _dio;

  AppDio(this._dio) {
    _dio.options.headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzYxMTIyMzE5LCJpYXQiOjE3NTg1MzAzMTksImp0aSI6IjVmMzljYzkyOTRjMTQ0YzdiNDk1OTMwODc4NWE0OTIwIiwidXNlcl9pZCI6IjMifQ.XIHFtjThZGYEbPDXRZZB41bw9q0Yrqd1uL-g723gg1A',
      // 'Content-Type': 'application/json',
    };
  }

  addToken(String token) {
    dio.options.headers.addAll({'Authorization': 'Bearer $token'});
  }
}
