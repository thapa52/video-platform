import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../theme/app_colors.dart';

class TypeAheadWidget extends StatelessWidget {
  final String hintText;
  final TextStyle? style;
  final Color? hintColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BoxBorder? border;
  final TextEditingController? controller;
  final Widget Function(Map<String, dynamic>) itemWidget;
  final void Function(Map<String, dynamic>) onSelected;
  final Future<List<Map<String, dynamic>>> Function(String) suggestion;

  // Constructor to receive parameters
  const TypeAheadWidget({
    super.key,
    required this.hintText,
    this.style,
    this.hintColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.border,
    this.controller,
    required this.itemWidget,
    required this.onSelected,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    final internalController = TextEditingController();
    return TypeAheadField<Map<String, dynamic>>(
      controller: controller ?? internalController,
      builder: (context, textController, focusNode) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: border ??
                Border.all(
                  color: AppColors.gray,
                  width: 1,
                ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  focusNode: focusNode,
                  style: style ??
                      TextStyle(
                        color: hintColor ?? AppColors.text,
                        fontFamily: fontFamily ?? 'Montserrat',
                        fontSize: fontSize ?? 16,
                        fontWeight: fontWeight ?? FontWeight.w400,
                      ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: style ??
                        TextStyle(
                          color: hintColor ?? AppColors.text,
                          fontFamily: fontFamily ?? 'Montserrat',
                          fontSize: fontSize ?? 16,
                          fontWeight: fontWeight ?? FontWeight.w400,
                        ),
                  ),
                ),
              ),
              Icon(
                Icons.search,
                color: AppColors.text,
              ),
            ],
          ),
        );
      },
      itemBuilder: (context, Map<String, dynamic> suggestion) {
        return itemWidget(suggestion); // ✅ using the suggestion dynamically
      },
      onSelected: (Map<String, dynamic> value) {
        onSelected(value); // ✅ call the function properly
      },
      suggestionsCallback: (search) {
        return suggestion(search); // ✅ return future suggestions
      },
    );
  }
}
