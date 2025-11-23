import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/model/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/product/data/models/sideOptions_model.dart';
import 'package:hungry/features/product/data/models/toppings_model.dart';
import 'package:hungry/features/product/data/repo/sideoptions_repo.dart';
import 'package:hungry/features/product/data/repo/toppings_repo.dart';
import 'package:hungry/features/product/widget/addToCart_btn.dart';
import 'package:hungry/features/product/widget/costum_product_desc.dart';
import 'package:hungry/features/product/widget/spicy_slider.dart';
import 'package:hungry/features/product/widget/options_card.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    super.key,
    required this.productImage,
    required this.productId,
    required this.productPrice,
    required this.productName,
    required this.productDesc,
  });

  final String productImage;
  final int productId;
  final String productName;
  final String productPrice;
  final String productDesc;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  double spicy = 0.0;
  bool isAddingToCart = false;

  final ToppingsRepo toppingsRepo = ToppingsRepo();
  final SideOptionsRepo sideOptionsRepo = SideOptionsRepo();

  List<ToppingsModel>? toppings;
  List<SideOptionsModel>? sideOptions;

  CartRepo cartRepo = CartRepo();
  List<int> selectedToppings = [];
  List<int> selectedSideOptions = [];

  @override
  void initState() {
    super.initState();
    getToppings();
    getSideOptions();
  }

  Future<void> getToppings() async {
    final res = await toppingsRepo.getToppings();
    if (!mounted) return;
    setState(() => toppings = res.cast<ToppingsModel>());
  }

  Future<void> getSideOptions() async {
    final res = await sideOptionsRepo.getSideOptions();
    if (!mounted) return;
    setState(() => sideOptions = res.cast<SideOptionsModel>());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = toppings == null || sideOptions == null;

    return Skeletonizer(
      enabled: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Info
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                widget.productImage,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                      'assets/images/placeholder.png',
                                      height: 120,
                                    ),
                              ),
                            ),
                            const Gap(5),
                            CustomText(
                              text: widget.productName,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),

                            CustomText(
                              text: "${widget.productPrice} \$",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),

                        const Gap(10),
                        Expanded(
                          child: SpicySlider(
                            spicy: spicy,
                            onChanged: (value) => setState(() => spicy = value),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    CustomProductDesc(
                      text: widget.productDesc,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ],
                ),

                const Gap(40),

                // Toppings Section
                CustomText(
                  text: "Toppings",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const Gap(15),
                if (toppings == null || toppings!.isEmpty)
                  const CustomText(text: "There are no Toppings now")
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: toppings!
                          .map(
                            (topping) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: OptionsCard(
                                imagePath: topping.image,
                                topping: topping.name,
                                selectedOptions: selectedToppings,
                                toppingId: topping.id,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                const Gap(25),

                // Side Options Section
                CustomText(
                  text: "Side Options",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const Gap(15),
                if (sideOptions == null || sideOptions!.isEmpty)
                  const CustomText(
                    text: "There are no Side Options now",
                    fontSize: 16,
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: sideOptions!
                          .map(
                            (option) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: OptionsCard(
                                imagePath: option.image,
                                topping: option.name,
                                toppingId: option.id,
                                selectedOptions: selectedSideOptions,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                const Gap(40),

                // Add to Cart Button
                isAddingToCart
                    ? Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                          animating: true,
                          radius: 18,
                        ),
                      )
                    : AddtocartBtn(
                        width: double.infinity,
                        height: 70,
                        fontSize: 20,
                        btnBackground: AppColors.primaryColor,
                        titleColor: Colors.white,
                        onTap: () async {
                          try {
                            setState(() => isAddingToCart = true);

                            final cartItem = CartModel(
                              productId: widget.productId,
                              quantity: 1,
                              toppings: selectedToppings,
                              sideOptions: selectedSideOptions,
                              spicy: spicy == 0.0 ? 0.1 : spicy,
                            );

                            await cartRepo.addToCart(
                              CartItemModel(items: [cartItem]),
                            );

                            setState(() => isAddingToCart = false);

                            Get.snackbar(
                              "Item added successfully",
                              "You can check your cart.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.primaryColor,
                              duration: const Duration(seconds: 2),
                              colorText: Colors.white,
                            );
                          } on ApiErrors catch (e) {
                            setState(() => isAddingToCart = false);
                            Get.snackbar(
                              "Failed to add item",
                              e.message,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            setState(() => isAddingToCart = false);
                            Get.snackbar(
                              "Something went wrong",
                              "Failed to add item to cart.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
