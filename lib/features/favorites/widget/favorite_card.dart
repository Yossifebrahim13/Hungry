import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/features/favorites/data/favorites_repo.dart';
import 'package:hungry/features/home/data/product_model.dart';
import 'package:hungry/shared/custom_snack_bar.dart';

Map<int, Timer> _debounceTimers = {};
FavoritesRepo favoritesRepo = FavoritesRepo();

Widget favoriteCard(ProductModel item, {required VoidCallback onUpdate}) {
  bool isFav = item.isFavorite;

  return StatefulBuilder(
    builder: (context, setState) {
      void toggleFavorite() {
        setState(() => isFav = !isFav);
        item.isFavorite = isFav;

        _debounceTimers[item.id]?.cancel();
        _debounceTimers[item.id] = Timer(
          const Duration(milliseconds: 500),
          () async {
            try {
              await favoritesRepo.toggleFavorite(item.id);
            } catch (e) {
              setState(() {
                isFav = !isFav;
                item.isFavorite = isFav;
              });

              String errorMsg = 'Error toggling favorite';
              if (e is ApiErrors) {
                if (e.message.contains('429')) {
                  errorMsg = 'Too many requests, please try again later';
                } else {
                  errorMsg = e.message;
                }
              }
              customSnackBar('Error', errorMsg, Colors.red);
            }
          },
        );
      }

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Row(
          children: [
            /// Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                item.image,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/test/pngwing 12.png",
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${item.price} EGP",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                      Text(item.rating),
                    ],
                  ),
                ],
              ),
            ),

            /// Favorite Icon (remove)
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: toggleFavorite,
            ),
          ],
        ),
      );
    },
  );
}
