import 'dart:async';
import 'package:get/get.dart';
import 'package:hungry/features/favorites/data/favorites_repo.dart';
import 'package:hungry/features/home/data/product_model.dart';

class FavoritesController extends GetxController {
  final FavoritesRepo favoritesRepo = FavoritesRepo();

  RxList<ProductModel> favoriteProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    loadFavorites();
    super.onInit();
  }

  Future<void> loadFavorites() async {
    try {
      final data = await favoritesRepo.getFavoriteProducts();
      favoriteProducts.assignAll(data);
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      await favoritesRepo.toggleFavorite(productId);

      loadFavorites();

    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }
}
