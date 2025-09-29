
import 'package:dio/dio.dart';

class Failure {
  final int? statusCode;
  final String message;

  Failure({
    this.statusCode = -1,
    required this.message,
  });

  factory Failure.handleError(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(
          message:
              "Connection timeout. Please check your internet connection and try again.",
        );
      case DioExceptionType.sendTimeout:
        return Failure(
          message: "Request sending timeout. Please try again later.",
        );
      case DioExceptionType.receiveTimeout:
        return Failure(
          message: "Response receiving timeout. Please try again later.",
        );
      case DioExceptionType.badCertificate:
        return Failure(
          message: "Invalid certificate. Please contact support.",
        );
      case DioExceptionType.badResponse:
        String errorMessage = "An unknown error occurred. Please try again later.";
        
        if (exception.response?.data != null) {
          if (exception.response!.data is Map<String, dynamic>) {
            // إذا كان الـ response Map، نبحث عن "error" أو "message"
            Map<String, dynamic> data = exception.response!.data;
            errorMessage = data['error'] ?? data['message'] ?? errorMessage;
          } else if (exception.response!.data is String) {
            // إذا كان الـ response String مباشرة
            errorMessage = exception.response!.data;
          }
        }
        
        return Failure(
          message: errorMessage,
        );
      case DioExceptionType.cancel:
        return Failure(
          message: "Request was cancelled. Please try again.",
        );
      case DioExceptionType.connectionError:
        return Failure(
          message:
              "Connection error. Please check your internet connection and try again.",
        );
      case DioExceptionType.unknown:
        return Failure(
          message: "An unknown error occurred. Please try again later.",
        );
    }
  }
}
