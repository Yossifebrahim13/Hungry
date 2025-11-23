import 'package:hungry/core/api/api_service.dart';
import 'package:hungry/features/home/data/product_model.dart';

class ProductRepo {
  final ApiService _apiService = ApiService();

  /// Get Products
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get("/products");
      return (response['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  /// Search Products

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _apiService.get(
        '/products',
        params: {'search': query},
      );
      return (response['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  /// Get Categories

  Future<List<FoodCategory>> getCategories() async {
    try {
      final response = await _apiService.get("/categories");
      print("Categories Response: $response");
      return (response['data'] as List)
          .map((e) => FoodCategory.fromJson(e))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }


}
