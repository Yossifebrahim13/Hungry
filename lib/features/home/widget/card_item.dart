import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/shared/custom_text.dart';

class CardItem extends StatefulWidget {
  const CardItem({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.description,
    required this.rate,
  });

  final String imagePath;
  final String itemName;
  final String description;
  final String rate;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem>
    with SingleTickerProviderStateMixin {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.imagePath,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: 0,
                  left: 0,
                  
                  child: Image.asset(ImagePath.shadow)),
              ],
            ),

            const Gap(10),

            CustomText(
              text: widget.itemName,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),

            CustomText(
              text: widget.description,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),

            Gap(12),

            Row(
              children: [
                CustomText(text: "⭐ ${widget.rate}"),
                const Spacer(),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFav = !isFav;
                    });
                  },
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 150),
                    scale: isFav ? 1.2 : 1.0,
                    curve: Curves.easeInOut,
                    child: Icon(
                      isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isFav ? AppColors.primaryColor : Colors.grey,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
