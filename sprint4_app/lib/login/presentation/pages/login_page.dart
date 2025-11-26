import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/login/presentation/view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginPage({super.key, required this.viewModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void dispose() {
    widget.viewModel.emailController.dispose();
    widget.viewModel.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: widget.viewModel.formKey,
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
                        controller: widget.viewModel.emailController,
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
                        controller: widget.viewModel.passwordController,
                        obscureText: !widget.viewModel.isPasswordVisible,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              widget.viewModel.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                widget.viewModel.isPasswordVisible = !widget.viewModel.isPasswordVisible;
                              });
                            },
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
                      ElevatedButton(
                        onPressed: () async {
                          final logged = widget.viewModel.isLoading ? null : await widget.viewModel.handleLogin();
                          if (logged == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login realizado com sucesso!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              context.go('/');
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ocorreu algum problema, tente novamente.'),
                              backgroundColor: Colors.redAccent,
                            ),
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
                        child: widget.viewModel.isLoading
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
                      OutlinedButton.icon(
                        onPressed: () {
                          print('Login com Google');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey[800]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.g_mobiledata, color: Colors.white, size: 24),
                        label: Text(
                          'Continuar com Google',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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
      })
    );
  }
}