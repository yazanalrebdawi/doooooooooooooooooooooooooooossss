<<<<<<< HEAD

=======
>>>>>>> zoz
import 'package:dio/dio.dart';

class Failure {
  final int? statusCode;
  final String message;

<<<<<<< HEAD
  Failure({
    this.statusCode = -1,
    required this.message,
  });
=======
  Failure({this.statusCode = -1, required this.message});
>>>>>>> zoz

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
<<<<<<< HEAD
        return Failure(
          message: "Invalid certificate. Please contact support.",
        );
      case DioExceptionType.badResponse:
        String errorMessage = "An unknown error occurred. Please try again later.";
        
=======
        return Failure(message: "Invalid certificate. Please contact support.");
      case DioExceptionType.badResponse:
        String errorMessage =
            "An unknown error occurred. Please try again later.";

>>>>>>> zoz
        if (exception.response?.data != null) {
          if (exception.response!.data is Map<String, dynamic>) {
            // إذا كان الـ response Map، نبحث عن "error" أو "message"
            Map<String, dynamic> data = exception.response!.data;
<<<<<<< HEAD
            errorMessage = data['error'] ?? data['message'] ?? errorMessage;
=======
            errorMessage =
                data['error'] ??
                data['message'] ??
                // لو فيه non_field_errors نعرضه
                (data['non_field_errors'] != null &&
                        data['non_field_errors'] is List &&
                        data['non_field_errors'].isNotEmpty
                    ? data['non_field_errors'][0].toString()
                    : errorMessage);
            errorMessage;
>>>>>>> zoz
          } else if (exception.response!.data is String) {
            // إذا كان الـ response String مباشرة
            errorMessage = exception.response!.data;
          }
        }
<<<<<<< HEAD
        
        return Failure(
          message: errorMessage,
        );
      case DioExceptionType.cancel:
        return Failure(
          message: "Request was cancelled. Please try again.",
        );
=======

        return Failure(message: errorMessage);
      case DioExceptionType.cancel:
        return Failure(message: "Request was cancelled. Please try again.");
>>>>>>> zoz
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
<<<<<<< HEAD
=======

//?-----------------------------------------------------------------------------------
//?--------       Type Failure          ----------------------------------------------
//?-----------------------------------------------------------------------------------

//* Refresh
class FailureRefresh extends Failure {
  FailureRefresh({super.message = 'Refresh failed'});
}

//?-------------------------------------------------

//* Wrong
class FailureWrong extends Failure {
  FailureWrong({super.message = 'An error occurred!'});
}
//?-------------------------------------------------

//* Server
class FailureServer extends Failure {
  FailureServer({super.message = 'Server error!'});
}
//?-------------------------------------------------

//* No Data ( Empty )
class FailureNoData extends Failure {
  FailureNoData({super.message = 'No Data'});
}
//?-------------------------------------------------

//* No Connection
class FailureNoConnection extends Failure {
  FailureNoConnection({super.message = 'No Connection , Pleas Try Agen'});
}

//?-------------------------------------------------
>>>>>>> zoz
