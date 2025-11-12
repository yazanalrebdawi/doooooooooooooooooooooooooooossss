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
        final responseData = exception.response?.data;

        if (responseData != null) {
          if (responseData is Map<String, dynamic>) {
            Map<String, dynamic> data = responseData;

            // 🧠 أولاً: نحاول نقرأ رسائل السيرفر العادية
            errorMessage = data['error'] ??
                data['message'] ??
                (data['non_field_errors'] != null &&
                        data['non_field_errors'] is List &&
                        data['non_field_errors'].isNotEmpty
                    ? data['non_field_errors'][0].toString()
                    : errorMessage);

            if (errorMessage ==
                "An unknown error occurred. Please try again later.") {
              final extractedErrors = data.values
                  .whereType<List>()
                  .expand((e) => e)
                  .map((e) => e.toString())
                  .join('\n');

              if (extractedErrors.isNotEmpty) {
                errorMessage = extractedErrors;
              }
            }
          } else if (responseData is String) {
            errorMessage = responseData;
          }
        }

        return Failure(message: errorMessage);

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
