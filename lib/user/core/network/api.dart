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
      log('📥 Response status code: ${response.statusCode}');
      log('📥 Response data: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 205) {
        return Right(response.data as T);
      } else {
        log('❌ Non-success status code: ${response.statusCode}');
        log('❌ Response data: ${response.data}');
        return Left(Failure(message: response.data.toString()));
      }
    } on DioException catch (e) {
      log('❌ DioException caught: ${e.type}');
      log('❌ DioException message: ${e.message}');
      log('❌ DioException response: ${e.response?.data}');
      log('❌ DioException status code: ${e.response?.statusCode}');
      return Left(Failure.handleError(e));
    } catch (e) {
      log('❌ Generic exception: $e');
      // For non-Dio exceptions, wrap as a generic Failure
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, T>> post<T>({required ApiRequest apiRequest}) async {
    log('📤 POST Request to: ${apiRequest.url}');
    log('📤 POST Data: ${apiRequest.data}');
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
