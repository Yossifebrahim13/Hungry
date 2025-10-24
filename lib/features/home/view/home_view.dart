import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/home/widget/card_item.dart';
import 'package:hungry/features/home/widget/food_category.dart';
import 'package:hungry/features/home/widget/search_field.dart';
import 'package:hungry/features/home/widget/user_header.dart';
import 'package:hungry/features/product/view/product_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.user});

  final UserModel? user;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ['All', 'Combo', 'Slider', 'Classic'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            /// Header Section
            SliverAppBar(
              pinned: true,
              floating: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 155,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Column(
                  children: [
                    UserHeader(user: widget.user),
                    SizedBox(height: 20),
                    SearchField(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoodCategory(
                      selectedIndex: selectedIndex,
                      category: category,
                    ),
                  ],
                ),
              ),
            ),

            /// Grid Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: 6,
                  (context, index) => GestureDetector(
                    onTap: () => Get.to(() => ProductView()),
                    child: const CardItem(
                      imagePath: ImagePath.homeTest,
                      itemName: "Cheese Burger",
                      description: "Wendy's Burger",
                      rate: "4.9",
                    ),
                  ),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
