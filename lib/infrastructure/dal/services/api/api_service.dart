import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../theme/app_colors.dart';
import '../../daos/printlog.dart';
import '../../daos/widgets/snackbar_widget.dart';

class ApiService<T> {
  // final String baseUrl = 'http://188.245.228.179:8082';
  final String baseUrl = 'http://16.52.0.119/api';

  Future<T> get(String path) async {
    final token = GetStorage().read('token') ?? '';

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };
    final response =
        await http.get(Uri.parse('$baseUrl/$path'), headers: headers);
    final jsonResponse = jsonDecode(response.body);
    printLog(
        '[GET] jsonResponse->$jsonResponse, statusCode ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonResponse as T;
    }

    String errorMessage =
        '${jsonResponse['error'] != null ? jsonResponse['error'][0] : jsonResponse['message']}';

    if (response.statusCode == 401) {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    } else {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    }
  }

  Future<T> post(String path, {Map<String, dynamic> body = const {}}) async {
    final token = GetStorage().read('token') ?? '';

    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    final jsonResponse =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;
    printLog(
        '[POST] response $jsonResponse, statusCode ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonResponse as T;
    }

    String errorMessage =
        '${jsonResponse['error'] != null ? jsonResponse['error'][0] : jsonResponse['message']}';

    if (response.statusCode == 401) {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    } else {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    }
  }

  Future<T> patch(String path, {Map<String, dynamic> body = const {}}) async {
    final token = GetStorage().read('token') ?? '';

    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.patch(
      Uri.parse('$baseUrl/$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    final jsonResponse =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;
    printLog('[PATCH] response $jsonResponse');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return jsonResponse as T;
    }

    String errorMessage =
        '${jsonResponse['error'] != null ? jsonResponse['error'][0] : jsonResponse['message']}';

    if (response.statusCode == 401) {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    } else {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    }
  }

  Future<T> put(String path, {Map<String, dynamic> body = const {}}) async {
    final token = GetStorage().read('token') ?? '';

    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse('$baseUrl/$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    final jsonResponse =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;
    printLog('[PUT] response $jsonResponse');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return jsonResponse as T;
    }

    String errorMessage =
        '${jsonResponse['error'] != null ? jsonResponse['error'][0] : jsonResponse['message']}';

    if (response.statusCode == 401) {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    } else {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    }
  }

  Future<T> delete(String path) async {
    final token = GetStorage().read('token') ?? '';

    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/$path'),
      headers: headers,
    );

    final jsonResponse =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;
    printLog('[DELETE] response $jsonResponse');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return jsonResponse as T;
    }

    String errorMessage =
        '${jsonResponse['error'] != null ? jsonResponse['error'][0] : jsonResponse['message']}';

    if (response.statusCode == 401) {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    } else {
      if (jsonResponse.containsKey('status') &&
          jsonResponse['status'] == false) {
        showErrorInToast(errorMessage, response.statusCode);
      }
      return [] as T;
    }
  }

  showErrorInToast(dynamic message, int statusCode) {
    final bool hasMessage =
        message != null && message.toString().trim().isNotEmpty;

    final String finalMessage = hasMessage
        ? message.toString()
        : 'Request failed with status: $statusCode.';

    return SnackbarWidget(
      message: finalMessage,
      icon: Icons.error,
      backgroundColor: AppColors.red[800],
      snackPosition: SnackPosition.TOP,
    );
  }
}
