import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/features/favorites/data/controller/favorite_controller.dart';
import 'package:hungry/features/favorites/widget/favorite_card.dart';
import 'package:hungry/shared/custom_text.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});

  final FavoritesController controller = Get.put(
    FavoritesController(),
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadFavorites,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const CustomText(
            text: "Favorites",
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.favoriteProducts.isEmpty) {
            return const Center(
              child: Text("No favorites yet", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = controller.favoriteProducts[index];

              return favoriteCard(
                product,
                onUpdate: () => controller.toggleFavorite(product.id),
              );
            },
          );
        }),
      ),
    );
  }
}
