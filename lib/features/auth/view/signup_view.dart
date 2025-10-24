import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hungry/core/api/api_errors.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/constants/image_path.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/widget/custom_btn.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_snack_bar.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_textform.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  AuthRepo authRepo = AuthRepo();
  bool isLoading = false;

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => isLoading = true);
        final user = await authRepo.signup(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (user != null) {
          customSnackBar(
            "Success",
            "You have successfully Signed Up.",
            AppColors.primaryColor,
          );
          Get.offAll(Root());
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
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
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
        body: SafeArea(
          child: Column(
            children: [
              const Gap(100),
              SvgPicture.asset(ImagePath.logo, color: AppColors.primaryColor),
              const Gap(20),
              CustomText(
                text: "Create Your Account, start your trip",
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              const Gap(40),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.only(
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
                            hintText: "Your Name",
                            controller: nameController,
                          ),
                          const Gap(25),
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
                              : CustomAuthBtn(text: "Sign Up", onTap: signup),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Already have an account? ",
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(LoginView());
                                },
                                child: CustomText(
                                  text: 'Log in',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
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
