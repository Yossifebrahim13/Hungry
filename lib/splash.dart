import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  /// Animation Logic
  late AnimationController _controller;
  late Animation<double> _fadeLogo;
  late Animation<double> _scaleLogo;
  late Animation<double> _fadeBottom;
  late Animation<Offset> _slideBottom;

  /// Auth Logic

  AuthRepo authRepo = AuthRepo();

  Future<void> checkLogin() async {
    final user = await authRepo.autoLogin();
    if (authRepo.isGuest) {
      Get.offAll(() => Root());
    } else if (user != null) {
      Get.offAll(() => Root());
    } else {
      Get.offAll(() => LoginView());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    // Logo animation
    _fadeLogo = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _scaleLogo = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Bottom animation
    _fadeBottom = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _slideBottom = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    Future.delayed(const Duration(seconds: 3), checkLogin);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(300),
            FadeTransition(
              opacity: _fadeLogo,
              child: ScaleTransition(
                scale: _scaleLogo,
                child: SvgPicture.asset(ImagePath.logo, height: 120),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: _fadeBottom,
              child: SlideTransition(
                position: _slideBottom,
                child: Image.asset(ImagePath.splash),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
