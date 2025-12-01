import 'package:flutter/material.dart';
import 'package:sprint4_app/common/service/authentication/login_method.dart';

class LoginButton extends StatelessWidget {
  final LoginMethod method;
  final VoidCallback onPressed;
  final bool? isLoading;

  late final Color _backgroundColor = method == LoginMethod.email
      ? Colors.blue
      : Colors.black;
  late final Color _borderColor = method == LoginMethod.email
      ? Colors.transparent
      : Colors.grey[800]!;

  LoginButton({
    super.key,
    required this.method,
    required this.onPressed,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: method == LoginMethod.email
          ? isLoading != null && (isLoading ?? false)
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                method == LoginMethod.google
                    ? Image.asset(
                        'images/google_icon.png',
                        width: 20,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.apple, size: 26, color: Colors.white),

                SizedBox(width: 5),

                Text(
                  'Sign in with ${method == LoginMethod.google ? 'Google' : 'Apple'}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
    );
  }
}
