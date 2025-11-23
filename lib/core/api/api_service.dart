import 'package:dio/dio.dart';
import 'package:hungry/core/api/api_exceptions.dart';
import 'package:hungry/core/api/dio_client.dart';
import 'dart:io';

class ApiService {
  final DioClient _dioClient = DioClient();

  /// -------------------- GET --------------------
  Future<dynamic> get(String endPoint, {dynamic params}) async {
    try {
      final response = await _dioClient.dio.get(
        endPoint,
        queryParameters: params,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleErrors(e);
    }
  }

  /// -------------------- POST --------------------
  Future<dynamic> post(
    String endPoint,
    dynamic data, {
    bool isFormData = false,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : data,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleErrors(e);
    }
  }

  /// -------------------- PUT --------------------
  Future<dynamic> put(
    String endPoint,
    Map<String, dynamic> data, {
    bool isFormData = false,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : data,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleErrors(e);
    }
  }

  /// -------------------- DELETE --------------------
  Future<dynamic> delete(
    String endPoint,
    Map<String, dynamic> data, {
    dynamic params,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        endPoint,
        data: data,
        queryParameters: params,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleErrors(e);
    }
  }

  /// -------------------- UPLOAD IMAGE (Helper) --------------------
  Future<dynamic> uploadProfileData({
    required String endpoint,
    required String name,
    required String email,
    required String address,
    String? visa,
    File? imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'address': address,
        if (visa != null && visa.isNotEmpty) 'visa': visa,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _dioClient.dio.put(endpoint, data: formData);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleErrors(e);
    }
  }

  void clearAuthHeader() {
    _dioClient.options.headers.remove('Authorization');
    print('🧹 Auth header cleared from Dio');
  }
}
