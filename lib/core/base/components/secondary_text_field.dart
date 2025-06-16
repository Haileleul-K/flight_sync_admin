import 'package:flight_sync_admin/core/styles/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool centerInput;
  final int maxLine;
  final TextEditingController? controller;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  const SecondaryTextField({
    Key? key,
    this.enabled = true,
    this.controller,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.centerInput = false,
    this.maxLine = 1,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            color: ColorThemes.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          maxLines: maxLine,
          onChanged: onChanged,
          enabled: enabled,
          validator: validator,
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorThemes.inputGreyColor,
            hintText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(3.r)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
}
