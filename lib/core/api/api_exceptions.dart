import 'package:dio/dio.dart';
import 'package:hungry/core/api/api_errors.dart';

class ApiExceptions {
  static ApiErrors handleErrors(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    if (statusCode != null) {
      if (data is Map<String, dynamic> && data['massage'] != null) {
        return ApiErrors(message: data['massage'], statusCode: statusCode);
      }
    }

    

    if (statusCode == 302) {
      return ApiErrors(message: 'Email already exists');
    }
    if (statusCode == 404) {
      return ApiErrors(message: 'Email is not Correct');
    }
    if (statusCode == 401) {
      return ApiErrors(message: 'Password is not Correct');
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiErrors(message: 'Bad Connection');
      case DioExceptionType.badResponse:
        return ApiErrors(message: error.toString());

      default:
        return ApiErrors(message: 'Something went wrong');
    }
  }
}
