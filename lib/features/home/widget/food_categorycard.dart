import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class FoodCategoryCard extends StatefulWidget {
  const FoodCategoryCard({
    super.key,
    required this.selectedIndex,
    required this.category,
  });
  final int selectedIndex;
  final List category;

  @override
  State<FoodCategoryCard> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategoryCard> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.category.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: CustomText(
                text: widget.category[index],
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          );
        }),
      ),
    );
  }
}
