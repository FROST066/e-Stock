import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.controller,
    this.validatorFun,
    required this.hintText,
    required this.prefixIcon,
    this.textInputType,
    this.obscureText,
    this.maxLines,
  });
  TextEditingController? controller;
  String hintText;
  IconData prefixIcon;
  TextInputType? textInputType;
  bool? obscureText;
  int? maxLines;
  String? Function(String?)? validatorFun;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        obscureText: obscureText ?? false,
        style: const TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 1),
            hintText: hintText,
            // hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: appGrey,
            iconColor: Colors.black),
        validator: validatorFun ?? (value) => null,
      ),
    );
  }
}
