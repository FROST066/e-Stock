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
    this.textAlign,
    this.onChanged,
  });
  TextEditingController? controller;
  String hintText;
  IconData? prefixIcon;
  TextInputType? textInputType;
  bool? obscureText, autofocus;
  int? maxLines;
  TextAlign? textAlign;
  String? Function(String?)? validatorFun;
  void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 5),
      child: TextFormField(
        textAlign: textAlign ?? TextAlign.start,
        onChanged: onChanged ?? (value) {},
        autofocus: autofocus ?? false,
        maxLines: maxLines ?? 1,
        controller: controller,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            labelText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null

            // filled: true,
            // fillColor: appGrey,
            // iconColor: Colors.black
            ),
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
    required this.labelText,
    this.autofocus,
  });
  TextEditingController? controller;
  String labelText;
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
        // style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 1),
            labelText: widget.labelText,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: GestureDetector(
                onTap: () => setState(() {
                      obscureText = !obscureText;
                    }),
                child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility))),
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
