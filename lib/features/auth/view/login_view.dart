import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/signup_view.dart';
import 'package:hungry/features/auth/widget/custom_btn.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_snack_bar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_textform.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthRepo authRepo = AuthRepo();

  bool isLoading = false;
  bool isGuestLoding = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final user = await authRepo.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (user != null) {
          customSnackBar(
            "Success",
            "You have successfully Logged In.",
            AppColors.primaryColor,
          );
          Get.offAll(() => Root());
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
        String errorMessage = 'An unexpected error occurred.';
        if (e is ApiErrors) {
          errorMessage = e.message;
        }
        customSnackBar("Error", errorMessage, Colors.red);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const Gap(120),
              SvgPicture.asset(ImagePath.logo, color: AppColors.primaryColor),
              const Gap(20),
              CustomText(
                text: "Welcome Back, Discover the best fast food.",
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              const Gap(60),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const Gap(20),
                          CustomTextform(
                            isPassword: false,
                            hintText: "Email Address",
                            controller: emailController,
                          ),
                          const Gap(25),
                          CustomTextform(
                            isPassword: true,
                            hintText: "Password",
                            controller: passwordController,
                          ),
                          const Gap(40),
                          isLoading
                              ? CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: size.width * 0.06,
                                )
                              : CustomAuthBtn(text: "Log In", onTap: login),
                          const Gap(25),
                          isGuestLoding
                              ? CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: size.width * 0.06,
                                )
                              : CustomAuthBtn(
                                  text: "Guest",
                                  onTap: () => Get.offAll(Root()),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Don't have an account? ",
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              TextButton(
                                onPressed: () =>
                                    Get.to(() => const SignupView()),
                                child: CustomText(
                                  text: 'Create an account',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
