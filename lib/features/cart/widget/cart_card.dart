import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.desc,
    this.onAdd,
    this.onMinus,
    this.onRemove, required this.quantity,
    
  });
  final String imagePath, itemName, desc;
  final Function()? onAdd;
  final Function()? onMinus;
  final Function()? onRemove;
  final  int quantity ;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(imagePath , fit: BoxFit.contain, width: 100,),
                CustomText(text: itemName, fontSize: 18),
                CustomText(text: desc, color: Colors.grey.shade800),
              ],
            ),
            Gap(90),
            Column(
              children: [
                Row(
                  children: [
                    CustomButton(
                      onTap: onAdd,
                      width: 40,
                      height: 40,
                      fontSize: 25,
                      btnBackground: AppColors.primaryColor,
                      titleColor: Colors.white,
                      icon: Icon(CupertinoIcons.add, color: Colors.white),
                    ),
                    Gap(20),
                    CustomText(text: quantity.toString(), fontSize: 30),
                    Gap(20),
                    CustomButton(
                      onTap: onMinus,
                      width: 40,
                      height: 40,
                      fontSize: 30,
                      btnBackground: AppColors.primaryColor,
                      titleColor: Colors.white,
                      icon: Icon(CupertinoIcons.minus, color: Colors.white),
                    ),
                  ],
                ),
                Gap(20),
                CustomButton(
                  onTap: onRemove,
                  width: 150,
                  height: 50,
                  fontSize: 25,
                  btnBackground: AppColors.primaryColor,
                  titleColor: Colors.white,
                  title: "Remove",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
