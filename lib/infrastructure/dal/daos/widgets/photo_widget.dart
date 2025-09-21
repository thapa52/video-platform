import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../services/controllers/photo_controller.dart';
import '../printlog.dart';
import 'text_widget.dart';

class PhotoWidget extends StatelessWidget {
  final PhotoController controller = Get.find();

  PhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasPhotos = controller.fileList.isNotEmpty;
      printLog(
          'PhotoWidget hasPhotos->$hasPhotos, fileList->${controller.fileList}');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasPhotos ? _buildHeader(context) : buildAddPrompt(),
          if (hasPhotos) _buildPhotoList(),
        ],
      );
    });
  }

  Widget buildAddPrompt() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: controller.pickAndUploadImage,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo, color: AppColors.brand[700]),
            const SizedBox(width: 10),
            TextWidget(
              text: 'Attach a photo',
              textColor: AppColors.brand[700],
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: 'Photos',
            fontWeight: FontWeight.w600,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                controller.toggleEditMode();
              } else if (value == 'delete') {
                Get.bottomSheet(
                  _buildDeleteConfirmation(),
                  backgroundColor: Colors.white,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'edit', child: TextWidget(text: 'Edit')),
              const PopupMenuItem(
                  value: 'delete', child: TextWidget(text: 'Delete')),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoList() {
    final canAddMore = controller.fileList.length < 4;

    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.fileList.length + (canAddMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.fileList.length) {
            final file = controller.fileList[index];
            return Padding(
              padding: index == 0
                  ? EdgeInsets.only(left: 0)
                  : EdgeInsets.only(left: 10),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: file['url'].toString().startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: file['url'],
                              httpHeaders: {
                                'Authorization': 'Bearer ${controller.token}',
                              },
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image.file(
                              File(file['url']),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )),
                  Obx(() {
                    return controller.isEditMode.value
                        ? Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () =>
                                  controller.deleteImage(file['fileId']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: controller.pickAndUploadImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 30),
                        TextWidget(
                          text: 'Add Photo\n${controller.fileList.length}/4',
                          textAlign: TextAlign.center,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDeleteConfirmation() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        children: [
          TextWidget(
            text: 'Delete all this photos?',
            textColor: AppColors.text,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: TextWidget(
                  text: 'Cancel',
                  textColor: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  controller.deleteAllPhotos();
                  Get.back();
                },
                child: TextWidget(
                  text: 'Delete All',
                  textColor: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
