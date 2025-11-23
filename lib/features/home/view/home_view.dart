import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/favorites/data/favorites_repo.dart';
import 'package:hungry/features/home/data/product_model.dart';
import 'package:hungry/features/home/data/product_repo.dart';
import 'package:hungry/features/home/widget/card_item.dart';
import 'package:hungry/features/home/widget/food_categorycard.dart';
import 'package:hungry/features/home/widget/search_field.dart';
import 'package:hungry/features/home/widget/user_header.dart';
import 'package:hungry/features/product/view/product_view.dart';
import 'package:hungry/shared/custom_snack_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isGuest = false;
  UserModel? currentUser;
  AuthRepo authRepo = AuthRepo();

  TextEditingController searchController = TextEditingController();

  List<FoodCategory>? categories;
  List<ProductModel>? products;
  List<ProductModel>? searchResults;
  int selectedIndex = 0;

  final ProductRepo productRepo = ProductRepo();
  FavoritesRepo favoritesRepo = FavoritesRepo();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await getProfileData();
    //await getCategories();
    await getProducts();
  }

  Future<void> getProfileData() async {
    if (isGuest) return;
    try {
      final user = await authRepo.getProfileData();
      if (!mounted) return;
      setState(() => currentUser = user);
    } catch (e) {
      if (!mounted) return;
      String errorMsg = 'Error';
      if (e is ApiErrors) errorMsg = e.message;
      customSnackBar('Error', errorMsg, Colors.red);
    }
  }

  Future<void> getCategories() async {
    final res = await productRepo.getCategories();
    if (!mounted) return;
    setState(() => categories = res);
  }

  Future<void> getProducts() async {
    final res = await productRepo.getProducts();
    if (!mounted) return;
    setState(() {
      products = res;
      searchResults = res;
    });
  }

  final Map<int, Timer> _debounceTimers = {};

  void toggleFavorite(int productId) {
    _debounceTimers[productId]?.cancel();
    _debounceTimers[productId] = Timer(
      const Duration(milliseconds: 500),
      () async {
        try {
          await favoritesRepo.toggleFavorite(productId);
        } catch (e) {
          String errorMsg = 'Error toggling favorite';
          if (e is ApiErrors && e.message.contains('429')) {
            errorMsg = 'Too many requests, please try again later';
          } else if (e is ApiErrors) {
            errorMsg = e.message;
          }
          customSnackBar('Error', errorMsg, Colors.red);

          final index = products!.indexWhere((p) => p.id == productId);
          if (index != -1) {
            setState(() {
              products![index].isFavorite = !products![index].isFavorite;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Skeletonizer(
          enabled: products == null,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                toolbarHeight: 155,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                    children: [
                      UserHeader(
                        userImageUrl: currentUser?.image,
                        userName: currentUser?.name,
                      ),
                      const SizedBox(height: 20),
                      SearchField(
                        controller: searchController,
                        onChanged: (value) {
                          final query = value.toLowerCase();
                          setState(() {
                            products = searchResults
                                ?.where(
                                  (p) => p.name.toLowerCase().contains(query),
                                )
                                .toList();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FoodCategoryCard(
                    selectedIndex: selectedIndex,
                    category: ['All', 'Combo', 'Slider', 'Classic'],
                  ),
                ),
              ),
              if (products == null)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 250),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                )
              else if (products!.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No products available right now.'),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products![index];
                      return GestureDetector(
                        onTap: () => Get.to(
                          () => ProductView(
                            productImage: product.image,
                            productName: product.name,
                            productDesc: product.desc,
                            productId: product.id,
                            productPrice: product.price,
                          ),
                        ),
                        child: CardItem(
                          imagePath: product.image,
                          itemName: product.name,
                          description: product.desc,
                          rate: product.rating,
                          isFavorite: product.isFavorite,
                          onFavoriteToggle: (newValue) {
                            setState(() {
                              products![index].isFavorite = newValue;
                            });
                            toggleFavorite(product.id);
                          },
                        ),
                      );
                    }, childCount: products!.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
