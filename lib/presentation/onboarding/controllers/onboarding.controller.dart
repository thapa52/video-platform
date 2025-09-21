import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../.env';
import '../../../domain/core/interfaces/utility.dart';
import '../../../infrastructure/dal/daos/printlog.dart';
import '../../../infrastructure/dal/daos/setStorage/storage.dart';
import '../../../infrastructure/dal/daos/widgets/snackbar_widget.dart';
import '../../../infrastructure/dal/daos/widgets/text_widget.dart';
import '../../../infrastructure/dal/services/api/api_service.dart';
import '../../../infrastructure/dal/services/middleware/biometric_auth.dart';
import '../../../infrastructure/theme/app_colors.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  late BiometricAuth biometricAuth;
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final isChecked = false.obs;
  final loading = false.obs;
  final biometricLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isFormValid = false.obs;
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  loginWithPin() async {
    Get.bottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      Obx(
        () => Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 22),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: TextWidget(
                              text: 'Login',
                              textColor: Color(0xFF111827),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextWidget(
                            text: 'Email',
                            textColor: AppColors.text[700],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: AppColors.text,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              // Simple email pattern
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 15),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                color: AppColors.text,
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
                                  width: 1,
                                  color: AppColors.gray[400]!,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.gray[400]!,
                                ),
                                borderRadius: BorderRadius.circular(8),
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
                                  width: 1,
                                  color: Color(0xffEFEFEF),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextWidget(
                            text: 'PIN',
                            textColor: AppColors.text[700],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: AppColors.text,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            controller: passwordController,
                            obscureText: isPasswordHidden.value,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
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
                                  togglePasswordVisibility();
                                },
                                icon: isPasswordHidden.value
                                    ? const Icon(
                                        Icons.visibility,
                                        color: AppColors.text,
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                        color: AppColors.text,
                                      ),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 20, right: 20, top: 15, bottom: 15),
                              hintText: 'Enter 6-digit pin',
                              hintStyle: TextStyle(
                                color: AppColors.text,
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
                                  width: 1,
                                  color: AppColors.gray[400]!,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.gray[400]!,
                                ),
                                borderRadius: BorderRadius.circular(8),
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
                                  width: 1,
                                  color: Color(0xffEFEFEF),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  toggleCheckbox();
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(),
                                  child: isChecked.value
                                      ? Icon(
                                          Icons.check_box_outlined,
                                          color: AppColors.brand[700],
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                          color: AppColors.text,
                                        ),
                                ),
                              ),
                              TextWidget(
                                text: 'Remember Me',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.text,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              loginWithBasicAuth();
                            } else {
                              showFormFillWarning();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                            backgroundColor: isFormValid.value
                                ? AppColors.brand[700]
                                : AppColors.gray[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: loading.value == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                )
                              : TextWidget(
                                  text: 'Login',
                                  textColor: AppColors.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.gray[400]!,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginWithBiometric() async {
    biometricLoading.value = true;

    String? refreshToken = GetStorage().read('refreshToken');
    printLog('refreshToken->$refreshToken');
    if (refreshToken == null) {
      printLog('No refresh token found');
      return;
    }

    try {
      final String clientId = kClientId;
      final String clientSecret = kClientSecret;

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';
      final response = await http.get(
        Uri.parse(
          '${ApiService().baseUrl}/oauth2/refresh_token?refresh_token=$refreshToken',
        ),
        headers: {
          'Authorization': basicAuth,
        },
      );
      final data = json.decode(response.body);
      printLog('biometric response -> $data');

      String errorMessage = '';

      if (response.statusCode == 200) {
        Storage().setToken(token: data['access_token']);
        Storage().setRefreshToken(refreshToken: data['refresh_token']);
        Storage().setExpiresIn(expiresIn: data['expires_in']);
        await parseJwt(data['access_token']);
        await Future.delayed(
          Duration(milliseconds: 500),
          () {
            Get.offAllNamed('dashboard');
          },
        );
      }

      if (data.containsKey('status') && data['status'] == false) {
        errorMessage =
            '${data['error'] != null ? data['error'][0] : data['message']}';
        showLoginError(errorMessage);
      }
      biometricLoading.value = false;
    } catch (e) {
      biometricLoading.value = false;
      printLog('biometric failed: $e');
    }
  }

  Future<void> loginWithBasicAuth() async {
    if (emailController.text == '' || passwordController.text == '') {
      showFormFillWarning();
      return;
    }
    printLog('email: ${emailController.text}');
    printLog('password: ${passwordController.text}');
    loading.value = true;
    try {
      final String clientId = kClientId;
      final String clientSecret = kClientSecret;

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

      final response = await http.post(
        Uri.parse('${ApiService().baseUrl}/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': basicAuth, // 🔐 This is the basic auth header
        },
        body: {
          'grant_type': 'password',
          'username': emailController.text,
          'password': passwordController.text,
        },
      );
      final data = json.decode(response.body);
      printLog('login response -> $data');

      String errorMessage = '';

      if (response.statusCode == 200) {
        await Utility().manageAuthentication(data);
        await parseJwt(data['access_token']);
        await Future.delayed(
          Duration(milliseconds: 500),
          () {
            Get.offAllNamed('dashboard');
          },
        );
        emailController.text = '';
        passwordController.text = '';
        isChecked.value = false;
      }

      if (data.containsKey('status') && data['status'] == false) {
        errorMessage =
            '${data['error'] != null ? data['error'][0] : data['message']}';
        showLoginError(errorMessage);
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
      printLog('Login failed: $e');
    }
  }

  void showFormFillWarning() async {
    SnackbarWidget(
      message: 'Please enter both email and password.',
      icon: Icons.error,
      backgroundColor: AppColors.text[900],
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showLoginError(String errorMessage) async {
    SnackbarWidget(
      message: errorMessage,
      icon: Icons.error,
      backgroundColor: AppColors.red[800],
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> parseJwt(String accessToken) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

    printLog('Decoded Token: $decodedToken');
    if (decodedToken.isNotEmpty) {
      if (decodedToken.containsKey('user')) {
        var userId = decodedToken['user']['id'];
        await Storage().setUserID(userId: userId);
        await getUserDetailsById(userId);
      }
    }
  }

  Future<void> getUserDetailsById(id) async {
    try {
      final response = await ApiService().get('users/$id');
      printLog('user response -> $response');
      if (response['status'] == true) {
        final userInfo = response['data'];
        Storage().setUserInfo(userInfo: userInfo);
      }
    } catch (e) {
      printLog('Error while getting user details -> $e');
    }
  }

  void validateForm() {
    final email = emailController.text.trim();
    final pin = passwordController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    isFormValid.value =
        email.isNotEmpty && pin.length == 6 && emailRegex.hasMatch(email);
  }

  @override
  void onInit() {
    biometricAuth = Get.put(BiometricAuth());
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
