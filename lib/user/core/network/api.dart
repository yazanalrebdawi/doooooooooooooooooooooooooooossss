import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'api_request.dart';
import 'failure.dart';

class API {
  final Dio dio;

  API({required this.dio});

  Future<Either<Failure, T>> _handleRequest<T>({
    required Future<Response> Function() request,
  }) async {
    try {
      final Response response = await request();
      log('Status code: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 205) {
        return Right(response.data as T);
      } else {
        // Handle error response with proper message extraction
        String errorMessage = "An unknown error occurred. Please try again later.";
        final responseData = response.data;
        
        if (responseData != null) {
          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['error'] ??
                responseData['message'] ??
                responseData['detail'] ??
                (responseData['non_field_errors'] != null &&
                        responseData['non_field_errors'] is List &&
                        responseData['non_field_errors'].isNotEmpty
                    ? responseData['non_field_errors'][0].toString()
                    : errorMessage);
            
            // Try to extract from nested error fields
            if (errorMessage == "An unknown error occurred. Please try again later.") {
              final extractedErrors = responseData.values
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
        
        log('❌ API Error Response: $errorMessage');
        return Left(Failure(
          statusCode: response.statusCode,
          message: errorMessage,
        ));
      }
    } on DioException catch (e) {
      log('❌ DioException: ${e.type} - ${e.message}');
      log('❌ DioException response: ${e.response?.data}');
      log('❌ DioException status code: ${e.response?.statusCode}');
      return Left(Failure.handleError(e));
    } catch (e, stackTrace) {
      log('❌ Non-Dio Exception: $e');
      log('❌ Stack trace: $stackTrace');
      // For non-Dio exceptions, wrap as a generic Failure
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, T>> post<T>({required ApiRequest apiRequest}) async {
    return _handleRequest(
      request: () => dio.post(apiRequest.url, data: apiRequest.data),
    );
  }

  Future<Either<Failure, T>> get<T>({required ApiRequest apiRequest}) async {
    return _handleRequest(
      request: () => dio.get(apiRequest.url, data: apiRequest.data),
    );
  }

  Future<Either<Failure, T>> put<T>({required ApiRequest apiRequest}) async {
    return _handleRequest(
      request: () => dio.put(apiRequest.url, data: apiRequest.data),
    );
  }

  Future<Either<Failure, T>> delete<T>({required ApiRequest apiRequest}) async {
    return _handleRequest(
      request: () => dio.delete(apiRequest.url, data: apiRequest.data),
    );
  }
}
