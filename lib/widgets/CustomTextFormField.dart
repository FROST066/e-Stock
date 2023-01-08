import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      this.textInputType,
      this.obscureText});
  TextEditingController controller;
  String hintText;
  IconData prefixIcon;
  TextInputType? textInputType;
  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: appGrey,
      ),
      child: TextFormField(
        obscureText: obscureText ?? false,
        style: const TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: textInputType ?? TextInputType.name,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            border: InputBorder.none,
            iconColor: Colors.black),
        // validator: (value) {
        //   return value == null || value == ""
        //       ? "              Ce champ est obligatoire"
        //       : null;
        // },
      ),
    );
  }
}
