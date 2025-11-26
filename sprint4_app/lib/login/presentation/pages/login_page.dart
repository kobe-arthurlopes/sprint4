import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';
import 'package:sprint4_app/login/presentation/components/sign_in_button.dart';
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _didPressSignInButton({
    required BuildContext context,
    required SignInMethod method,
    required String? errorMessage,
  }) async {
    bool condition = false;

    final email = method == SignInMethod.emailPassword ? _emailController.text : null;
    final password = method == SignInMethod.emailPassword ? _passwordController.text : null;

    _viewModel.configureSignIn(
      method: method,
      email: email,
      password: password,
    );

    final isAuthenticated = await _viewModel.login();

    switch (method) {
      case SignInMethod.emailPassword:
        final isFormValid = (_formKey.currentState?.validate() ?? false);
        condition = isAuthenticated && isFormValid;
      default:
        condition = isAuthenticated;
    }

    final loginMessage = condition
      ? 'Login realizado com sucesso!'
      : errorMessage ?? 'Ocorreu algum problema, tente novamente.';

    final snackBarColor = condition ? Colors.green : Colors.redAccent;

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loginMessage),
        backgroundColor: snackBarColor,
      )
    );

    if (condition) context.go(HomePage.routeId);
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
                      Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 24),
                      
                      Text(
                        'Bem-vindo!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      
                      Text(
                        'Insira suas credenciais para continuar',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48),

                      // Campo de Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400]),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Campo de Senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !data.isPasswordVisible,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              data.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: _viewModel.togglePasswordVisibility,
                          ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 4) {
                            return 'A senha deve ter pelo menos 4 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),

                      // Esqueci a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navegar para tela de recuperação de senha
                            print('Esqueceu a senha');
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Entrar
                      ElevatedButton(
                        onPressed: () async {
                          print('Login com email e senha');

                          // 'mocked.email@gmail.com'
                          // 1234

                          await _didPressSignInButton(
                            context: context,
                            method: SignInMethod.emailPassword, 
                            errorMessage: data.errorMessage,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: data.isLoading
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
                              ),
                      ),
                      SizedBox(height: 24),

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
                      SignInButton(
                        isGoogle: true,
                        onPressed: () async {
                          print('Login com Google');
                          await _didPressSignInButton(
                            context: context, 
                            method: SignInMethod.google, 
                            errorMessage: data.errorMessage,
                          );
                        },
                      ),
                      SizedBox(height: 16),

                      // Login com Apple
                      SignInButton(
                        isGoogle: false,
                        onPressed: () async {
                          print('Login com Apple');
                          await _didPressSignInButton(
                            context: context, 
                            method: SignInMethod.apple, 
                            errorMessage: data.errorMessage,
                          );
                        },
                      ),
                      SizedBox(height: 32),

                      // Link para Cadastro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não tem uma conta? ',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navegar para tela de cadastro
                              print('Ir para cadastro');
                            },
                            child: Text(
                              'Cadastre-se',
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
      }
    );
  }
}