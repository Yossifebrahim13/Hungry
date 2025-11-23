import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/home/widget/custom_item_desc.dart';
import 'package:hungry/shared/custom_text.dart';

class CardItem extends StatefulWidget {
  const CardItem({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.description,
    required this.rate,
    required this.isFavorite,
    this.onFavoriteToggle,
  });

  final String imagePath;
  final String itemName;
  final String description;
  final String rate;
  final bool isFavorite;
  final Function(bool)? onFavoriteToggle;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem>
    with SingleTickerProviderStateMixin {
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.isFavorite;
  }

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
                  child: Image.network(
                    widget.imagePath,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 80,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: 0,
                  left: 0,
                  child: Image.asset(ImagePath.shadow),
                ),
              ],
            ),
            const Gap(10),
            CustomText(
              text: widget.itemName,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            CustomItemDesc(
              text: widget.description,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
            const Gap(12),
            Row(
              children: [
                CustomText(text: "⭐ ${widget.rate}"),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() => isFav = !isFav);
                    widget.onFavoriteToggle?.call(isFav);
                  },
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 150),
                    scale: isFav ? 1.2 : 1.0,
                    curve: Curves.easeInOut,
                    child: Icon(
                      isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isFav ? Colors.red : Colors.grey,
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
