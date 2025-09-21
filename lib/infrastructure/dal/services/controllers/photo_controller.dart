import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../daos/printlog.dart';
import '../../daos/widgets/snackbar_widget.dart';
import '../api/api_response.dart';
import '../api/api_service.dart';

class PhotoController extends GetxController {
  final token = GetStorage().read('token') ?? '';

  var fileList = <Map<String, dynamic>>[].obs;
  var checkInRecordId = 0.obs;
  final RxBool isEditMode = false.obs;
  final siteId = ''.obs;
  final _dio = dio.Dio();
  final baseUrl = ApiService().baseUrl;

  final ImagePicker picker = ImagePicker();

  Future<void> initData(Map<String, dynamic> data, String siteid) async {
    siteId.value = siteid;
    final dto = data['checkInRecordResponseDTO'];
    printLog('PhotoController dto $dto, siteId->$siteId');

    if (dto != null && dto is Map<String, dynamic>) {
      checkInRecordId.value = dto['checkInRecordId'] ?? 0;

      printLog('PhotoController checkInRecordId $checkInRecordId');
      final files = dto['fileResponseList'];
      printLog('PhotoController files $files');
      if (files != null && files is List) {
        loadFiles(files);
      } else {
        fileList.clear();
        printLog('PhotoController fileList -> $fileList clear');
      }
    } else {
      // Null DTO means no check-in happened yet
      checkInRecordId.value = 0;
      fileList.clear();
      printLog(
          'PhotoController fileList -> $fileList clear, checkInRecordId->$checkInRecordId,');
    }
  }

  Future<void> loadFiles(List<dynamic>? files) async {
    if (files != null) {
      fileList.value = files.map((e) => Map<String, dynamic>.from(e)).toList();
      printLog('PhotoController fileList $fileList');
    }
  }

  Future<bool> uploadPhoto(int checkInRecordId, XFile file) async {
    try {
      printLog('Upload checkInRecordId: $checkInRecordId, file$file');
      // final token = GetStorage().read('token') ?? '';
      printLog('Upload token: $token');

      final headers = <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      };
      printLog('Upload headers: $headers');
      dio.FormData formData = dio.FormData.fromMap({
        'multipartFile': dio.MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: file.name,
        )
      });
      printLog('Upload formData: $formData');

      final response = await _dio.post(
        '$baseUrl/file?checkInRecordId=$checkInRecordId',
        data: formData,
        options: dio.Options(headers: headers),
      );

      printLog('Upload data: ${response.data}');
      return response.data['status'];
    } catch (e) {
      printLog('Upload failed: $e');
      return false;
    }
  }

  Future<void> pickAndUploadImage() async {
    if (checkInRecordId.value == 0 || siteId.value == '') {
      SnackbarWidget(
        message: 'CheckInRecord Id is missing',
        snackPosition: SnackPosition.TOP,
        icon: Icons.error,
      );
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final isSuccess = await uploadPhoto(
        checkInRecordId.value,
        picked,
      );

      if (isSuccess) {
        final newData = await ApiResponse().getCheckInRecordUser(siteId);
        if (newData.isNotEmpty) {
          initData(newData, siteId.value); // Refresh photos
        }
      }
    }
  }

  Future<bool> deletePhotoFromServer(int fileId) async {
    try {
      final response = await ApiService().delete('file/$fileId');
      return response['status'];
    } catch (e) {
      printLog('Delete image id $fileId failed: $e');
      return false;
    }
  }

  Future<void> deleteImage(int fileId) async {
    if (siteId.value == '') return;
    final isSuccess = await deletePhotoFromServer(fileId);

    if (isSuccess) {
      final newData = await ApiResponse().getCheckInRecordUser(siteId);
      if (newData.isNotEmpty) {
        initData(newData, siteId.value); // Refresh photos
      }
    }
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  Future<bool> deleteAllPhotoFromServer(
    int checkInRecordId,
  ) async {
    try {
      final response =
          await ApiService().delete('file/check-in-record/$checkInRecordId');
      return response['status'];
    } catch (e) {
      printLog('Delete image id $checkInRecordId failed: $e');
      return false;
    }
  }

  Future<void> deleteAllPhotos() async {
    if (checkInRecordId.value == 0 || siteId.value == '') return;

    final isSuccess = await deleteAllPhotoFromServer(checkInRecordId.value);

    if (isSuccess) {
      final newData = await ApiResponse().getCheckInRecordUser(siteId);
      if (newData.isNotEmpty) {
        initData(newData, siteId.value); // Refresh photos
      }
    }
  }
}
