import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../infrastructure/theme/app_colors.dart';
import 'controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // gradient visible behind
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent, // gradient visible
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // center: Alignment.topLeft,
                  // radius: 1.2,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 14, 20, 35), // bluish navy
                    Color.fromARGB(255, 6, 10, 21), // bluish navy
                    Color.fromARGB(255, 0, 0, 0), // black
                    Color.fromARGB(255, 1, 1, 1), // black
                    Color.fromARGB(255, 15, 20, 35), // dark bluish gray
                    Color.fromARGB(255, 25, 35, 49), // dark bluish gray
                  ],
                  stops: [
                    0.0,
                    0.35,
                    0.40,
                    0.60,
                    0.65,
                    1.0,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Form(
                          key: controller.formKey,
                          child: Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF364152),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  color: AppColors.white.withOpacity(0.2),
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.red[550],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.play_arrow_rounded,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: TextWidget(
                                          text: 'MiniStage',
                                          textColor: AppColors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  child: Center(
                                    child: TextWidget(
                                      text: 'Welcome Back',
                                      textColor: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                    child: TextWidget(
                                      text:
                                          'Sign in to Continue watching your shows',
                                      textAlign: TextAlign.center,
                                      fontSize: 14,
                                      textColor: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10, top: 10),
                                  child: TextWidget(
                                    text: 'Email',
                                    textColor: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      color: AppColors.text[400],
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    controller: controller.emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      // Simple email pattern
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      hintText: 'Enter your email',
                                      hintStyle: TextStyle(
                                        color: AppColors.text[400],
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      errorStyle: TextStyle(
                                        color: AppColors.red,
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: const Color(0xFF364152),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: const Color(0xFF364152),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: AppColors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: const Color(0xFF364152),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextWidget(
                                    text: 'Password',
                                    textColor: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: const Color(0xFF5F6573),
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    controller: controller.passwordController,
                                    obscureText:
                                        controller.isPasswordHidden.value,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.digitsOnly,
                                    //   LengthLimitingTextInputFormatter(6),
                                    // ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      } else if (value.length != 6) {
                                        return 'Password must be exactly 6 digits';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.togglePasswordVisibility();
                                        },
                                        icon: controller.isPasswordHidden.value
                                            ? Icon(
                                                Icons.visibility,
                                                color: AppColors.gray[800],
                                              )
                                            : Icon(
                                                Icons.visibility_off,
                                                color: AppColors.gray[800],
                                              ),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 15),
                                      hintText: 'Enter Your Password',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF5F6573),
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      errorStyle: TextStyle(
                                        color: AppColors.red,
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: const Color(0xFF364152),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: const Color(0xFF364152),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: AppColors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: const Color(0xFF364152),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(bottom: 30),
                                //   child: Row(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           controller.toggleCheckbox();
                                //         },
                                //         child: Container(
                                //           height: 20,
                                //           width: 20,
                                //           margin: EdgeInsets.only(right: 10),
                                //           decoration: BoxDecoration(),
                                //           child: controller.isChecked.value
                                //               ? Icon(
                                //                   Icons.check_box_outlined,
                                //                   color: AppColors.brand[700],
                                //                 )
                                //               : Icon(
                                //                   Icons.check_box_outline_blank,
                                //                   color: AppColors.text,
                                //                 ),
                                //         ),
                                //       ),
                                //       TextWidget(
                                //         text: 'Remember Me',
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w500,
                                //         textColor: AppColors.white,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                ElevatedButton(
                                  onPressed: () {
                                    // if (controller.formKey.currentState!
                                    //     .validate()) {
                                    //   controller.loginWithBasicAuth();
                                    // } else {
                                    //   controller.showFormFillWarning();
                                    // }
                                    Get.offAllNamed('dashboard');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(50),
                                    backgroundColor: AppColors.red[550],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: controller.loading.value
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                          ),
                                        )
                                      : TextWidget(
                                          text: 'Sign In',
                                          textColor: AppColors.white,
                                        ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Center(
                                    child: TextWidget(
                                      text: 'Don\'t have an account?',
                                      textAlign: TextAlign.center,
                                      fontSize: 16,
                                      textColor: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                    child: TextWidget(
                                      text: 'Sign Up now',
                                      textAlign: TextAlign.center,
                                      fontSize: 14,
                                      textColor: AppColors.red[150],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 30, bottom: 10),
                                  child: Center(
                                    child: TextWidget(
                                      text: 'Forgot Password?',
                                      textAlign: TextAlign.center,
                                      fontSize: 14,
                                      textColor: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
