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
    final isLoadingState = isLoading ?? false;
    
    return Semantics(
      button: true,
      enabled: !isLoadingState,
      label: _getSemanticLabel(),
      hint: _getSemanticHint(),
      onTap: isLoadingState ? null : onPressed,
      child: ElevatedButton(
        onPressed: isLoadingState ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: _borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _buildButtonContent(isLoadingState),
      ),
    );
  }

  Widget _buildButtonContent(bool isLoadingState) {
    if (method == LoginMethod.email) {
      return _buildEmailButtonContent(isLoadingState);
    }
    return _buildSocialButtonContent();
  }

  Widget _buildEmailButtonContent(bool isLoadingState) {
    if (isLoadingState) {
      return Semantics(
        label: 'Loading',
        liveRegion: true,
        child: ExcludeSemantics(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return ExcludeSemantics(
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSocialButtonContent() {
    final providerName = method == LoginMethod.google ? 'Google' : 'Apple';
    
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          method == LoginMethod.google
              ? Image.asset(
                  'assets/images/google_icon.png',
                  width: 20,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.apple, size: 26, color: Colors.white),
          
          SizedBox(width: 5),
          
          Text(
            'Sign in with $providerName',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _getSemanticLabel() {
    if (method == LoginMethod.email) {
      return isLoading ?? false ? 'Processing sign in' : 'Sign in button';
    }
    
    final providerName = method == LoginMethod.google ? 'Google' : 'Apple';
    return 'Sign in with $providerName button';
  }

  String _getSemanticHint() {
    if (isLoading ?? false) {
      return 'Please wait while processing';
    }
    
    if (method == LoginMethod.email) {
      return 'Double tap to sign in with email and password';
    }
    
    final providerName = method == LoginMethod.google ? 'Google' : 'Apple';
    return 'Double tap to sign in with your $providerName account';
  }
}