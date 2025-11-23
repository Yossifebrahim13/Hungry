import 'package:dio/dio.dart';
import '../../../core/api/api_exceptions.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/core/utils/pref_helpers.dart';
import 'package:hungry/features/auth/data/user_model.dart';

class AuthRepo {
  final ApiService apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentUser;

  /// ========================= LOGIN ========================= ///
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post('/login', {
        "email": email,
        "password": password,
      });

      if (response is ApiErrors) throw response;

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];

        if (code != 200 || data == null) {
          throw ApiErrors(message: msg ?? "Login failed");
        }

        final user = UserModel.fromJson(data);

        if (user.token != null) {
          /// clear old tokens/data before saving new one
          await PrefHelpers.clearToken();
          await PrefHelpers.saveToken(user.token!);
          print("🔐 New token saved after login: ${user.token}");
        }

        isGuest = false;
        _currentUser = user;

        /// small delay to make sure token is saved before moving
        await Future.delayed(const Duration(milliseconds: 300));

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

  /// ========================= SIGNUP ========================= ///
  Future<UserModel?> signup(String name, String email, String password) async {
    try {
      final response = await apiService.post('/register', {
        "name": name,
        "email": email,
        "password": password,
      });

      if (response is ApiErrors) throw response;

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final codenum = int.tryParse(code);

        if (codenum != 200 && codenum != 201) {
          throw ApiErrors(message: msg ?? "Signup failed");
        }

        final user = UserModel.fromJson(response['data']);

        if (user.token != null) {
          await PrefHelpers.clearToken();
          await PrefHelpers.saveToken(user.token!);
          print("🆕 Token saved after signup: ${user.token}");
        }

        isGuest = false;
        _currentUser = user;

        /// delay to ensure token sync
        await Future.delayed(const Duration(milliseconds: 300));

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

  /// ========================= PROFILE ========================= ///
  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelpers.getToken();
      print("📦 Fetching profile with token: $token");

      if (token == null || token == 'guest') {
        isGuest = true;
        return null;
      }

      final response = await apiService.get('/profile');

      if (response is Map<String, dynamic>) {
        final code = response['code'];
        final msg = response['message'];
        if (code != 200 || response['data'] == null) {
          throw ApiErrors(message: msg ?? "Failed to load profile");
        }

        final user = UserModel.fromJson(response['data']);
        _currentUser = user;
        return _currentUser;
      } 
    } on DioException catch (e) {
      throw ApiExceptions.handleErrors(e);
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
    return null;
  }

  /// ========================= UPDATE PROFILE ========================= ///
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

      if (response is ApiErrors) throw response;
      if (response is! Map<String, dynamic>) {
        throw ApiErrors(message: "Invalid response from server");
      }

      final msg = response['message'];
      final code = int.tryParse(response['code']?.toString() ?? '');
      if (code != 200 && code != 201) {
        throw ApiErrors(message: msg ?? "Unknown Error");
      }

      final updatedUser = UserModel.fromJson(response['data']);
      _currentUser = updatedUser;
      return updatedUser;
    } on DioException catch (e) {
      throw ApiExceptions.handleErrors(e);
    } catch (e) {
      throw ApiErrors(message: e.toString());
    }
  }

  /// ========================= LOGOUT ========================= ///
  Future<void> logout() async {
    try {
      await apiService.post('/logout', {});
    } catch (_) {
    }

    await PrefHelpers.clearToken();
    await PrefHelpers.saveToken('guest');
    _currentUser = null;
    isGuest = true;

    apiService.clearAuthHeader();

    print("🚪 User logged out — switched to guest mode");
  }

  /// ========================= GUEST MODE ========================= ///
  Future<void> continueAsGuest() async {
    isGuest = true;
    _currentUser = null;
    await PrefHelpers.clearToken();
    await PrefHelpers.saveToken('guest');
    print("👤 Continue as guest mode");
  }

  /// ========================= AUTO LOGIN ========================= ///
  Future<UserModel?> autoLogin() async {
  print(" Auto-login initiated...");

  final token = await PrefHelpers.getToken();
  print(" Current Token 🔑$token");

   // to check if token is valid
  if (token == null || token == 'guest') {
    print(" No valid token found, continuing as guest.");
    isGuest = true;
    _currentUser = null;
    return null;
  }

  try {
    final user = await getProfileData();

    if (user != null) {
      print("✅ Auto-login successful for user: ${user.name}");
      isGuest = false;
      _currentUser = user;
      return _currentUser;
    } else {
     
      print("❌ Auto-login failed, switching to guest mode.");
      await PrefHelpers.clearToken();
      await PrefHelpers.saveToken('guest');
      isGuest = true;
      _currentUser = null;
      return null;
    }
  } catch (e) {
    print("❌ Auto-login error: $e, switching to guest mode.");
    await PrefHelpers.clearToken();
    await PrefHelpers.saveToken('guest');
    isGuest = true;
    _currentUser = null;
    return null;
  }
}


  UserModel? get currentUser => _currentUser;
  bool get isLoggedin => !isGuest && _currentUser != null;
}
