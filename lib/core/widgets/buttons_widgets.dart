import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final Function(String? value) validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function()? suffixIconAction;
  final double horizontalPadding;
  final double verticalPadding;

  const AuthTextFormField(
      {super.key,
        required this.controller,
        required this.validator,
        required this.labelText,
        this.obscureText = false,
        this.prefixIcon,
        this.suffixIcon,
        this.suffixIconAction,
        this.horizontalPadding = 10,
        this.verticalPadding = 10, required Function(dynamic fullName)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
            onPressed: () {
              if (suffixIconAction != null) {
                suffixIconAction!();
              }
            },
            icon: Icon(
              suffixIcon,
              color: obscureText ? Colors.grey : const Color(0xFFd5c48e),
            ),
          )
              : null,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: (String? v) {
          return validator(v);
        },
      ),
    );
  }
}
