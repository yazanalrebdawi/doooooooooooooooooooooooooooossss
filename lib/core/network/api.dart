import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'api_request.dart';
import 'failure.dart';


class API {
  final Dio dio;

  API({
    required this.dio,
  });

  Future<Either<Failure, T>> _handleRequest<T>({required Future<Response> Function() request,}) async {
    
    try {
      final Response response = await request();
      log(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 205) {
        return Right(response.data);
      } else {
        return Left(Failure(message: response.data));
      }
    } on DioException catch (e) {
      return Left(Failure.handleError(e));
    } catch (e) {
      return Left(Failure.handleError(e as DioException));
    }
  }

  Future<Either<Failure, T>> post<T>({
    required ApiRequest apiRequest,
  }) async {
    return _handleRequest(
      request: () => dio.post(
        apiRequest.url,
        data: apiRequest.data,
      ),
    );
  }

  Future<Either<Failure, T>> get<T>({
    required ApiRequest apiRequest,
  }) async {
    return _handleRequest(
      request: () => dio.get(
        apiRequest.url,
        data: apiRequest.data,
      ),
    );
  }

  Future<Either<Failure, T>> put<T>({
    required ApiRequest apiRequest,
  }) async {
    return _handleRequest(
      request: () => dio.put(
        apiRequest.url,
        data: apiRequest.data,
      ),
    );
  }

  Future<Either<Failure, T>> delete<T>({
    required ApiRequest apiRequest,
  }) async {
    return _handleRequest(
      request: () => dio.delete(
        apiRequest.url,
        data: apiRequest.data,
      ),
    );
  }
}
