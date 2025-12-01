import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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

    // Anuncia resultado ao leitor de tela
    SemanticsService.sendAnnouncement(View.of(context), loginMessage, TextDirection.ltr);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loginMessage), backgroundColor: snackBarColor),
    );

    if (isLoginValid) {
      SemanticsService.sendAnnouncement(View.of(context), 'Redirecting to home page', TextDirection.ltr);
      context.go(HomePage.routeId);
    }
  }

  void _resetFields() {
    _emailController.text = '';
    _passwordController.text = '';

    if (_viewModel.data.value.isPasswordVisible) {
      _viewModel.togglePasswordVisibility();
    }

    // Anuncia reset dos campos
    SemanticsService.sendAnnouncement(View.of(context), 'Form fields have been reset', TextDirection.ltr);
  }

  @override
  Widget build(BuildContext content) {
    return ValueListenableBuilder<LoginData>(
      valueListenable: _viewModel.data,
      builder: (_, data, _) {
        return Semantics(
          label: data.isSignIn ? 'Sign in page' : 'Registration page',
          child: Scaffold(
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
                        // Logo - decorativo
                        ExcludeSemantics(
                          child: Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                        ),
                        SizedBox(height: 24),

                        // Título principal
                        Semantics(
                          header: true,
                          child: Text(
                            data.isSignIn ? 'Welcome!' : 'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Subtítulo
                        Semantics(
                          label: data.isSignIn
                              ? 'Enter your credentials to continue'
                              : 'Enter your information to register',
                          child: ExcludeSemantics(
                            child: Text(
                              data.isSignIn
                                  ? 'Enter your credentials to continue.'
                                  : 'Enter your information to register.',
                              style: TextStyle(color: Colors.grey[400], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 48),

                        // Campo de Email
                        Semantics(
                          container: true,
                          child: LoginTextField(
                            key: const Key('emailField'),
                            type: LoginTextFieldOption.email,
                            controller: _emailController,
                            validator: (value) {
                              final error = _viewModel.validateEmail(value);
                              if (error != null) {
                                SemanticsService.sendAnnouncement(View.of(context), 
                                  'Email validation error: $error',
                                  TextDirection.ltr,
                                );
                              }
                              return error;
                            },
                          ),
                        ),
                        SizedBox(height: 16),

                        // Campo de Senha
                        Semantics(
                          container: true,
                          child: LoginTextField(
                            key: const Key('passwordField'),
                            type: LoginTextFieldOption.password,
                            controller: _passwordController,
                            isVisible: data.isPasswordVisible,
                            onPressedSuffixIcon: () {
                              _viewModel.togglePasswordVisibility();
                              
                              // Anuncia mudança de visibilidade
                              final message = !data.isPasswordVisible
                                  ? 'Password is now visible'
                                  : 'Password is now hidden';
                              SemanticsService.sendAnnouncement(View.of(context), message, TextDirection.ltr);
                            },
                            validator: (value) {
                              final error = _viewModel.validatePassword(value);
                              if (error != null) {
                                SemanticsService.sendAnnouncement(View.of(context), 
                                  'Password validation error: $error',
                                  TextDirection.ltr,
                                );
                              }
                              return error;
                            },
                          ),
                        ),
                        SizedBox(height: 24),

                        // Botão de Login com Email
                        LoginButton(
                          key: const Key('emailLoginButton'),
                          method: LoginMethod.email,
                          onPressed: () async {
                            _viewModel.setMethod(LoginMethod.email);

                            final isFormValid = _formKey.currentState?.validate();

                            if (isFormValid == false) {
                              SemanticsService.sendAnnouncement(View.of(context), 
                                'Form has errors. Please correct them and try again',
                                TextDirection.ltr,
                              );
                            } else {
                              SemanticsService.sendAnnouncement(View.of(context), 
                                'Processing sign in with email',
                                TextDirection.ltr,
                              );
                            }

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
                          // Divisor com semântica
                          Semantics(
                            label: 'Or sign in with social accounts',
                            child: Row(
                              children: [
                                Expanded(
                                  child: ExcludeSemantics(
                                    child: Divider(color: Colors.grey[800]),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: ExcludeSemantics(
                                    child: Text(
                                      'OU',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ExcludeSemantics(
                                    child: Divider(color: Colors.grey[800]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Login com Google
                          LoginButton(
                            method: LoginMethod.google,
                            onPressed: () async {
                              SemanticsService.sendAnnouncement(View.of(context), 
                                'Opening Google sign in',
                                TextDirection.ltr,
                              );
                              
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

                              SemanticsService.sendAnnouncement(View.of(context), 
                                'Opening Apple sign in',
                                TextDirection.ltr,
                              );

                              _viewModel.setMethod(LoginMethod.apple);

                              await _didPressSignInButton(
                                context: context,
                                errorMessage: data.errorMessage,
                              );
                            },
                          ),
                          SizedBox(height: 32),
                        ],

                        // Link para Toggle entre Sign In/Register
                        Semantics(
                          button: true,
                          label: data.isSignIn
                              ? 'Switch to registration'
                              : 'Switch to sign in',
                          hint: data.isSignIn
                              ? 'Double tap to create a new account'
                              : 'Double tap to go back to sign in',
                          onTap: () {
                            _viewModel.toggleIsSignIn();
                            _resetFields();
                            
                            final message = data.isSignIn
                                ? 'Switched to registration page'
                                : 'Switched to sign in page';
                            SemanticsService.sendAnnouncement(View.of(context), message, TextDirection.ltr);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ExcludeSemantics(
                                child: Text(
                                  data.isSignIn
                                      ? "Don't have an account?"
                                      : 'Do you want to log in?',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _viewModel.toggleIsSignIn();
                                  _resetFields();
                                  
                                  final message = data.isSignIn
                                      ? 'Switched to registration page'
                                      : 'Switched to sign in page';
                                  SemanticsService.sendAnnouncement(View.of(context), message, TextDirection.ltr);
                                },
                                child: ExcludeSemantics(
                                  child: Text(
                                    data.isSignIn ? ' Register' : ' Go back',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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