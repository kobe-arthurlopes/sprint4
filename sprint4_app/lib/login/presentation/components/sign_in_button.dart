import 'package:flutter/material.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';

class SignInButton extends StatelessWidget {
  final SignInMethod method;
  final VoidCallback onPressed;
  final bool? isLoading;

  late final Color backgroundColor = method == SignInMethod.email
      ? Colors.blue
      : Colors.black;
  late final Color borderColor = method == SignInMethod.email
      ? Colors.transparent
      : Colors.grey[800]!;

  SignInButton({
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
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: method == SignInMethod.email
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
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                method == SignInMethod.google
                    ? Image.asset(
                        'images/google_icon.png',
                        width: 20,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.apple, size: 26, color: Colors.white),

                SizedBox(width: 5),

                Text(
                  'Continuar com ${method == SignInMethod.google ? 'Google' : 'Apple'}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
    );
  }
}
