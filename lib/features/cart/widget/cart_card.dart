import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/core/constants/app_colors.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.price,
    required this.quantity,
    this.onAdd,
    this.onMinus,
    this.onRemove,
    this.toppings = const [],
    this.sideOptions = const [],
  });

  final String imagePath;
  final String itemName;
  final String price;
  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onMinus;
  final VoidCallback? onRemove;
  final List<Map<String, dynamic>> toppings;
  final List<Map<String, dynamic>> sideOptions;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.3),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Gap(12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: itemName,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const Gap(5),
                      CustomText(
                        text: "\$$price",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                      const Gap(10),

                      // Quantity Buttons
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.minus),
                              onPressed: onMinus,
                              color: AppColors.primaryColor,
                              iconSize: 20,
                              padding: const EdgeInsets.all(4),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: CustomText(
                              text: quantity.toString(),
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.add),
                              onPressed: onAdd,
                              color: AppColors.primaryColor,
                              iconSize: 20,
                              padding: const EdgeInsets.all(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Remove Button
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                  tooltip: "Remove Item",
                ),
              ],
            ),

            const Gap(12),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 50,
              indent: 50,
            ),

            // Toppings Section
            if (toppings.isNotEmpty) ...[
              const CustomText(
                text: "Toppings:",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              const Gap(5),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: toppings.map((t) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          t['image'] ?? '',
                          width: 20,
                          height: 20,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t['name'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const Gap(10),
            ],

            // Side Options Section
            if (sideOptions.isNotEmpty) ...[
              const CustomText(
                text: "Side Options:",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              const Gap(5),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sideOptions.map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          s['image'] ?? '',
                          width: 20,
                          height: 20,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          s['name'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
