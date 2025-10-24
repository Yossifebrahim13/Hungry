import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/cart/widget/cart_card.dart';
import 'package:hungry/features/checkout/view/chekout_view.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/core/constants/app_colors.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int itemCount = 20;
  late List<int> quantites;
  @override
  void initState() {
    quantites = List.generate(itemCount, (_) => 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20, bottom: 100),
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return CartCard(
                quantity: quantites[index],
                imagePath: ImagePath.homeTest,
                itemName: "Cheese Burger",
                desc: "wendy's Burger",
                onAdd: () {
                  setState(() {
                    quantites[index]++;
                  });
                },
                onMinus: () {
                  setState(() {
                    if (quantites[index] > 1) quantites[index]--;
                  });
                },
                onRemove: () {
                  setState(() {});
                },
              );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Total",
                  color: AppColors.primaryColor,
                  fontSize: 20,
                ),
                CustomText(
                  text: "\$18",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              width: 120,
              height: 70,
              fontSize: 20,
              btnBackground: AppColors.primaryColor,
              titleColor: Colors.white,
              title: "Check Out",
              onTap: () {
                Get.to(ChekoutView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
