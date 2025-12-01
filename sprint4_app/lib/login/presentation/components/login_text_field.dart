import 'package:flutter/material.dart';

enum LoginTextFieldOption { email, password }

class LoginTextField extends StatelessWidget {
  final LoginTextFieldOption type;
  final TextEditingController? controller;
  final bool isVisible;
  final VoidCallback? onPressedSuffixIcon;
  final String? Function(String?)? validator;

  LoginTextField({
    super.key,
    required this.type,
    this.controller,
    this.isVisible = true,
    this.onPressedSuffixIcon,
    this.validator,
  });

  late final TextInputType? _keyboardType = type == LoginTextFieldOption.email
      ? TextInputType.emailAddress
      : null;

  late final String _labelText = type == LoginTextFieldOption.email
      ? "Email"
      : "Senha";

  late final IconData _prefixIconData = type == LoginTextFieldOption.email
      ? Icons.email_outlined
      : Icons.lock_outline;

  late final Widget? _suffixIcon = type == LoginTextFieldOption.password
      ? IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[400],
          ),
          onPressed: onPressedSuffixIcon,
        )
      : null;

  late final bool _obscureText = type == LoginTextFieldOption.password
      ? !isVisible
      : false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      keyboardType: _keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: _labelText,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(_prefixIconData, color: Colors.grey[400]),
        suffixIcon: _suffixIcon,
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}
