import 'package:e_stock/other/styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.controller,
    this.validatorFun,
    required this.hintText,
    this.prefixIcon,
    this.textInputType,
    this.autofocus,
    this.maxLines,
  });
  TextEditingController? controller;
  String hintText;
  IconData? prefixIcon;
  TextInputType? textInputType;
  bool? obscureText, autofocus;
  int? maxLines;
  String? Function(String?)? validatorFun;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        autofocus: autofocus ?? false,
        maxLines: maxLines ?? 1,
        style: const TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: appGrey,
            iconColor: Colors.black),
        validator: validatorFun ??
            (value) {
              if (value == null || value == "") {
                return "Ce champ est obligatoire";
              }
              return null;
            },
      ),
    );
  }
}

class CustomPasswordFormField extends StatefulWidget {
  CustomPasswordFormField({
    super.key,
    this.controller,
    this.validatorFun,
    required this.hintText,
    this.autofocus,
  });
  TextEditingController? controller;
  String hintText;
  bool? autofocus;
  String? Function(String?)? validatorFun;

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        autofocus: widget.autofocus ?? false,
        // maxLines: widget.maxLines ?? 1,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 1),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
                onTap: () => setState(() {
                      obscureText = !obscureText;
                    }),
                child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: appGrey,
            iconColor: Colors.black),
        validator: widget.validatorFun ??
            (value) {
              if (value == null || value == "") {
                return "Ce champ est obligatoire";
              }
            },
      ),
    );
  }
}
