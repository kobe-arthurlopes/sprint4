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
      : "Password";

  late final IconData _prefixIconData = type == LoginTextFieldOption.email
      ? Icons.email_outlined
      : Icons.lock_outline;

  late final bool _obscureText = type == LoginTextFieldOption.password
      ? !isVisible
      : false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: _getSemanticLabel(),
      hint: _getSemanticHint(),
      child: TextFormField(
        controller: controller,
        obscureText: _obscureText,
        keyboardType: _keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: _labelText,
          labelStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: ExcludeSemantics(
            child: Icon(_prefixIconData, color: Colors.grey[400]),
          ),
          suffixIcon: _buildSuffixIcon(),
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
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (type != LoginTextFieldOption.password) return null;

    return Semantics(
      button: true,
      label: isVisible ? 'Hide password' : 'Show password',
      hint: 'Double tap to toggle password visibility',
      onTap: onPressedSuffixIcon,
      child: IconButton(
        icon: ExcludeSemantics(
          child: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[400],
          ),
        ),
        onPressed: onPressedSuffixIcon,
        tooltip: isVisible ? 'Hide password' : 'Show password',
      ),
    );
  }

  String _getSemanticLabel() {
    if (type == LoginTextFieldOption.email) {
      return 'Email text field';
    }
    return 'Password text field';
  }

  String _getSemanticHint() {
    if (type == LoginTextFieldOption.email) {
      return 'Enter your email address';
    }
    
    if (isVisible) {
      return 'Enter your password. Password is visible';
    } else {
      return 'Enter your password. Password is hidden';
    }
  }
}