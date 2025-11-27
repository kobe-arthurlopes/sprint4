import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isGoogle;

  const SignInButton({super.key, this.onPressed, required this.isGoogle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[800]!),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isGoogle
            ? Image.asset(
              'images/google_icon.png',
              width: 20,
              fit: BoxFit.cover,
            )
            : Icon(
              Icons.apple,
              size: 26,
              color: Colors.white,
            ),

          SizedBox(width: 5),

          Text(
            'Continuar com ${isGoogle ? 'Google' : 'Apple'}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}