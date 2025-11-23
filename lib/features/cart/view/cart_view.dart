import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/cart/data/controller/cart_controler.dart';
import 'package:hungry/features/cart/widget/cart_card.dart';
import 'package:hungry/features/checkout/view/chekout_view.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_snack_bar.dart';
import 'package:hungry/shared/custom_text.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getCartItems();
      },
      child: Obx(() {
        if (controller.isGuest.value) {
          return guestView();
        }
      
        if (controller.isLoading.value || controller.isDeleting.value) {
          return const Center(child: CircularProgressIndicator());
        }
      
        final items = controller.cartModel.value?.cartData.items ?? [];
      
        return Scaffold(
          body: SafeArea(
            child: items.isEmpty
                ? const Center(
                    child: CustomText(text: "Your cart is empty", fontSize: 18),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 100),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
      
                        return CartCard(
                          quantity: controller.quantities[index],
                          imagePath: item.productImage,
                          itemName: item.productName,
                          price: item.price,
                          toppings: item.toppings,
                          sideOptions: item.sideOptions,
                          onAdd: () => controller.quantities[index]++,
                          onMinus: () {
                            if (controller.quantities[index] > 1) {
                              controller.quantities[index]--;
                            }
                          },
                          onRemove: () {
                            controller.deleteCartItem(item.itemId);
                          },
                        );
                      },
                    ),
                  ),
          ),
          bottomSheet: checkoutSection(controller),
        );
      }),
    );
  }

  Widget guestView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 100),
            const SizedBox(height: 20),
            const CustomText(text: "You are browsing as Guest", fontSize: 22),
            const SizedBox(height: 20),
            CustomButton(
              width: 200,
              height: 50,
              btnBackground: AppColors.primaryColor,
              title: "Login",
              titleColor: Colors.white,
              onTap: () => Get.offAll(() => LoginView()),
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget checkoutSection(CartController controller) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final cartItems = controller.cartModel.value?.cartData?.items ?? [];
        final total = controller.calculateTotalPrice();

        return Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Total",
                  color: AppColors.primaryColor,
                  fontSize: 20,
                ),
                CustomText(
                  text: "${total.toStringAsFixed(2)} \$",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              width: 180,
              height: 60,
              title: "Check Out",
              btnBackground: AppColors.primaryColor,
              titleColor: Colors.white,
              onTap: () {
                if (cartItems.isEmpty) {
                  customSnackBar(
                    "Warning",
                    "Your cart is empty!",
                    Colors.orange,
                  );
                  return;
                }
                Get.to(
                  () => CheckoutView(totalPrice: total.toStringAsFixed(2)),
                );
              },
              fontSize: 20,
            ),
          ],
        );
      }),
    );
  }
}
