import 'package:dio/dio.dart';

class Failure {
  final int? statusCode;
  final String message;

  Failure({this.statusCode = -1, required this.message});

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
        return Failure(message: "Invalid certificate. Please contact support.");
      case DioExceptionType.badResponse:
        String errorMessage =
            "An unknown error occurred. Please try again later.";
        if (exception.response?.data != null) {
          if (exception.response!.data is Map<String, dynamic>) {
            Map<String, dynamic> data = exception.response!.data;

            // Try multiple possible error message keys
            String? extractedMessage = data['error'] ??
                data['message'] ??
                data['detail'] ??
                data['error_message'] ??
                data['errors']?['message']?.toString() ??
                data['errors']?['detail']?.toString();

            // Check for field-specific errors (like password, username)
            if (extractedMessage == null || extractedMessage.isEmpty) {
              if (data['password'] != null) {
                if (data['password'] is List &&
                    (data['password'] as List).isNotEmpty) {
                  extractedMessage = data['password'][0].toString();
                } else if (data['password'] is String) {
                  extractedMessage = data['password'];
                }
              } else if (data['username'] != null) {
                if (data['username'] is List &&
                    (data['username'] as List).isNotEmpty) {
                  extractedMessage = data['username'][0].toString();
                } else if (data['username'] is String) {
                  extractedMessage = data['username'];
                }
              }
            }

            // Check for non_field_errors (common in Django REST framework)
            if (extractedMessage == null || extractedMessage.isEmpty) {
              if (data['non_field_errors'] != null &&
                  data['non_field_errors'] is List &&
                  (data['non_field_errors'] as List).isNotEmpty) {
                extractedMessage = data['non_field_errors'][0].toString();
              }
            }

            // Use extracted message if found, otherwise use default
            errorMessage = extractedMessage ?? errorMessage;
          } else if (exception.response!.data is String) {
            errorMessage = exception.response!.data;
          }
        }
        return Failure(
          statusCode: exception.response?.statusCode,
          message: errorMessage,
        );
      case DioExceptionType.cancel:
        return Failure(message: "Request was cancelled. Please try again.");
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

//----------------------
// Extended Failure Types
//----------------------

// Refresh
class FailureRefresh extends Failure {
  FailureRefresh({super.message = 'Refresh failed'});
}

// Wrong
class FailureWrong extends Failure {
  FailureWrong({super.message = 'An error occurred!'});
}

// Server
class FailureServer extends Failure {
  FailureServer({super.message = 'Server error!'});
}

// No Data (Empty)
class FailureNoData extends Failure {
  FailureNoData({super.message = 'No Data'});
}

// No Connection
class FailureNoConnection extends Failure {
  FailureNoConnection({super.message = 'No Connection, Please Try Again'});
}
