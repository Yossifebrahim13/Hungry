import 'package:dio/dio.dart';
import '../../../core/api/api_exceptions.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/core/utils/pref_helpers.dart';
import 'package:hungry/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentUser;

  // LOGIN
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post('/login', {
        "email": email,
        "password": password,
      });
      if (response is ApiErrors) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];

        if (code != 200 || data == null) {
          throw ApiErrors(message: msg ?? "Login failed");
        }

        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelpers.saveToken(user.token!);
        }
        isGuest = false;
        _currentUser = user;
        return user;
      } else {
        throw ApiErrors(message: "Invalid response from server");
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleErrors(e);
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
  }

  /// SIGNUP
  Future<UserModel?> signup(String name, String email, String password) async {
    try {
      final response = await apiService.post('/register', {
        "name": name,
        "email": email,
        "password": password,
      });
      if (response is ApiErrors) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final codenum = int.tryParse(code);

        if (codenum != 200 && codenum != 201) {
          throw ApiErrors(message: msg ?? "Signup failed");
        }

        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelpers.saveToken(user.token!);
        }
        isGuest = false;
        _currentUser = user;
        return user;
      } else {
        throw ApiErrors(message: "Invalid response from server");
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleErrors(e);
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
  }

  /// Get Profile Data

  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelpers.getToken();
      if (token == null || token == 'guest') {
        return null;
      }

      final response = await apiService.get('/profile');
      final user = UserModel.fromJson(response['data']);
      _currentUser = user;
      final code = response['code'];
      final msg = response['message'];
      if (code != 200 || response['data'] == null) {
        throw ApiErrors(message: msg ?? "Failed to load profile");
      }

      return user;
    } on DioException catch (e) {
      throw ApiExceptions.handleErrors(e);
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
  }

  /// Update Profile Data

  Future<UserModel?> updateProfileDate({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'address': address,
        if (visa != null && visa.isNotEmpty) 'visa': visa,
        if (imagePath != null && imagePath.isNotEmpty)
          'image': await MultipartFile.fromFile(
            imagePath,
            filename: 'profile.jpg',
          ),
      });

      final response = await apiService.post('/update-profile', formData);

      if (response is ApiErrors) {
        throw response;
      }
      if (response is! Map<String, dynamic>) {
        throw ApiErrors(message: "Invalid response from server");
      }

      final msg = response['message'];
      final code = response['code'];
      final data = response['data'];

      final coder = int.tryParse(code?.toString() ?? '');
      if (coder != 200 && coder != 201) {
        throw ApiErrors(message: msg ?? "Unknown Error");
      }
      final updatedUser = UserModel.fromJson(data);
      _currentUser = updatedUser;
      return updatedUser;
    } on DioException catch (e) {
      throw ApiExceptions.handleErrors(e);
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
  }

  /// Logout

  Future<void> logout() async {
    try {
      final response = await apiService.post('/logout', {});

      if (response == null || response is ApiErrors) {
        throw ApiErrors(message: "Logout failed");
      }

      await PrefHelpers.clearToken();
      _currentUser = null;
      isGuest = true;
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
  }

  /// Continue as a guest

  Future<void> continueAsGuest() async {
    isGuest = true;
    _currentUser = null;
    await PrefHelpers.saveToken('guest');
  }

  /// Auto Login

  Future<UserModel?> autoLogin() async {
    final token = await PrefHelpers.getToken();
    if (token == null || token == 'guest') {
      isGuest = true;
      _currentUser = null;
      return null;
    }
    isGuest = false;
    try {
      final user = await getProfileData();
      _currentUser = user;
      return _currentUser;
    } catch (e) {
      await PrefHelpers.clearToken();
      isGuest = true;
      _currentUser = null;
      return null;
    }
  }

  UserModel? get currentUser => _currentUser;

  bool get isLoggedin => !isGuest && _currentUser != null;
}
