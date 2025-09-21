import 'package:ecoland/infrastructure/dal/daos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';

class SnackbarWidget {
  final String? title;
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final SnackPosition? snackPosition;
  final Duration? duration;
  final double? borderRadius;
  final EdgeInsets? margin;

  SnackbarWidget({
    this.title,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.snackPosition,
    this.duration,
    this.borderRadius,
    this.margin,
  }) {
    _show();
  }

  void _show() {
    Get.snackbar(
      '',
      '',
      icon: icon == null
          ? SizedBox.shrink()
          : Icon(
              icon,
              color: AppColors.white,
            ),
      titleText: title == null
          ? SizedBox.shrink()
          : TextWidget(
              text: title ?? '',
              textColor: AppColors.white,
            ),
      messageText: TextWidget(
        text: message,
        textColor: AppColors.white,
      ),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? AppColors.text[900],
      duration: duration ?? Duration(seconds: 3),
      margin: margin ?? EdgeInsets.all(10),
      borderRadius: borderRadius ?? 10,
    );
  }
}
