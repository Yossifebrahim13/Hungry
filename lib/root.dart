import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/view/profile_view.dart';
import 'package:hungry/features/cart/view/cart_view.dart';
import 'package:hungry/features/favorites/data/controller/favorite_controller.dart';
import 'package:hungry/features/home/view/home_view.dart';
import 'package:hungry/features/favorites/view/favorites_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentScreen = 0;
  final List<Widget> screens = [
    HomeView(),
    CartView(),
    FavoritesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentScreen, children: screens),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          elevation: 5,
          backgroundColor: AppColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: currentScreen,
          onTap: (index) {
            setState(() {
              currentScreen = index;
            });
            if (index == 2) {
              Get.put(FavoritesController()).loadFavorites();
              }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart_fill),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: currentScreen == 2
                  ? const Icon(CupertinoIcons.heart_fill)
                  : const Icon(CupertinoIcons.heart),
              label: "Favorites",
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
