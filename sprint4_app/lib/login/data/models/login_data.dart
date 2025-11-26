class LoginData {
  bool isPasswordVisible;
  bool isLoading;
  bool isAuthenticated;
  String email;
  String password;
  String? errorMessage;

  LoginData({
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.email = '',
    this.password = '',
    this.errorMessage,
  });

  LoginData copyWith({
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isAuthenticated,
    String? email,
    String? password,
    String? errorMessage,
  }) {
    return LoginData(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}