import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextOverflow? overflow;

  // Constructor to receive parameters
  const TextWidget({
    Key? key,
    required this.text,
    this.textColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaler: TextScaler.linear(1.0),
      style: style ??
          TextStyle(
            color: textColor ?? AppColors.black,
            fontFamily: fontFamily ?? 'Montserrat',
            fontSize: fontSize ?? 16.0,
            fontWeight: fontWeight ?? FontWeight.w400,
            decoration: textDecoration ?? TextDecoration.none,
          ), // Default style if no style is provided
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
