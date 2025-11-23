import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/features/home/data/product_model.dart';

class FavoritesRepo {
  final ApiService _apiService = ApiService();

  /// Get Favorite Products

  Future<List<ProductModel>> getFavoriteProducts() async {
    try {
      final response = await _apiService.get("/favorites");
      return (response['data'] as List)
          .map((e) => ProductModel.fromJson(e, forceFavorite: true))
          .toList();
    } catch (e) {
      print('Error fetching favorite products: $e');
      return [];
    }
  }

  /// Toggle Favorite

  Future<String> toggleFavorite(int productId) async {
  try {
    final response = await _apiService.post('/toggle-favorite', {
      'product_id': productId,
    });

    print("TOGGLE FAVORITE RESPONSE: $response");

    if (response is Map<String, dynamic>) {
      return response['message'] ?? 'Success';
    }

    if (response is ApiErrors) {
      throw response;
    }

    return "Success";
  } catch (e) {
    print('Error toggling favorite: $e');
    if (e is ApiErrors) {
      return e.message;
    }
    return 'Error';
  }
}

}
