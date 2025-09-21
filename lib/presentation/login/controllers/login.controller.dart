import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../domain/core/interfaces/utility.dart';
import '../../../infrastructure/dal/daos/printlog.dart';
import '../../../infrastructure/dal/daos/setStorage/storage.dart';
import '../../../.env';
import '../../../infrastructure/dal/daos/widgets/snackbar_widget.dart';
import '../../../infrastructure/dal/services/api/api_service.dart';
import '../../../infrastructure/theme/app_colors.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final isChecked = false.obs;
  final isPasswordHidden = true.obs;
  final loading = false.obs;
  final isFormValid = false.obs;
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
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
