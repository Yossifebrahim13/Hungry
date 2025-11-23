import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_text.dart';

class AddtocartBtn extends StatelessWidget {
  const AddtocartBtn({
    super.key,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.btnBackground,
    required this.titleColor,
    this.onTap,
  });
  final double width;
  final double height;
  final double fontSize;
  final Color btnBackground;
  final Color titleColor;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: btnBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Add To Cart",
              color: titleColor,
              fontSize: fontSize,
            ),
            Gap(5),
            Icon(CupertinoIcons.shopping_cart, color: titleColor),
          ],
        ),
      ),
    );
  }
}
