import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/authentication/login_method.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';
import 'package:sprint4_app/login/presentation/components/login_button.dart';
import 'package:sprint4_app/login/presentation/components/login_text_field.dart';
import 'package:sprint4_app/login/presentation/view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  static const routeId = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel _viewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<LoginViewModel>();
    _setListeners();
  }

  void _setListeners() {
    _emailController.addListener(() {
      _viewModel.setEmail(_emailController.text);
    });

    _passwordController.addListener(() {
      _viewModel.setPassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _didPressSignInButton({
    required BuildContext context,
    required String? errorMessage,
    bool? isFormValid,
  }) async {
    final isLoginValid = await _viewModel.isLoginValid(
      isFormValid: isFormValid,
    );

    final loginMessage = isLoginValid
        ? 'Login successful!'
        : errorMessage ?? 'Something went wrong, please try again.';

    final snackBarColor = isLoginValid ? Colors.green : Colors.redAccent;

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loginMessage), backgroundColor: snackBarColor),
    );

    if (isLoginValid) context.go(HomePage.routeId);
  }

  void _resetFields() {
    _emailController.text = '';
    _passwordController.text = '';

    if (_viewModel.data.value.isPasswordVisible) {
      _viewModel.togglePasswordVisibility();
    }
  }

  @override
  Widget build(BuildContext content) {
    return ValueListenableBuilder<LoginData>(
      valueListenable: _viewModel.data,
      builder: (_, data, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo ou Título
                      Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                      SizedBox(height: 24),

                      Text(
                        data.isSignIn ? 'Welcome!' : 'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),

                      Text(
                        data.isSignIn
                            ? 'Enter your credentials to continue.'
                            : 'Enter your information to register.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48),

                      // Campo de Email
                      LoginTextField(
                        key: const Key('emailField'),
                        type: LoginTextFieldOption.email,
                        controller: _emailController,
                        validator: _viewModel.validateEmail,
                      ),
                      SizedBox(height: 16),

                      // Campo de Senha
                      LoginTextField(
                        key: const Key('passwordField'),
                        type: LoginTextFieldOption.password,
                        controller: _passwordController,
                        isVisible: data.isPasswordVisible,
                        onPressedSuffixIcon:
                            _viewModel.togglePasswordVisibility,
                        validator: _viewModel.validatePassword,
                      ),
                      SizedBox(height: 24),

                      // Login com email
                      LoginButton(
                        key: const Key('loginButtonEmail'),
                        method: LoginMethod.email,
                        onPressed: () async {
                          print('Login com email e senha');
                          _viewModel.setMethod(LoginMethod.email);

                          final isFormValid = _formKey.currentState?.validate();

                          await _didPressSignInButton(
                            context: context,
                            errorMessage: data.errorMessage,
                            isFormValid: isFormValid,
                          );
                        },
                        isLoading: data.isLoading,
                      ),
                      SizedBox(height: 24),

                      if (data.isSignIn) ...[
                        // Divisor
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[800])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OU',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[800])),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Login com Google
                        LoginButton(
                          method: LoginMethod.google,
                          onPressed: () async {
                            print('Login com Google');

                            _viewModel.setMethod(LoginMethod.google);

                            await _didPressSignInButton(
                              context: context,
                              errorMessage: data.errorMessage,
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        // Login com Apple
                        LoginButton(
                          method: LoginMethod.apple,
                          onPressed: () async {
                            print('Login com Apple');

                            _viewModel.setMethod(LoginMethod.apple);

                            await _didPressSignInButton(
                              context: context,
                              errorMessage: data.errorMessage,
                            );
                          },
                        ),
                        SizedBox(height: 32),
                      ],

                      // Link para Cadastro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.isSignIn
                                ? "Don't have an account "
                                : 'Do you want to log in? ',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          GestureDetector(
                            onTap: () {
                              _viewModel.toggleIsSignIn();
                              _resetFields();
                            },
                            child: Text(
                              data.isSignIn ? 'Register' : 'Go back',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
