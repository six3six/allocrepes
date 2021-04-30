import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.showLoginForm = false,
    this.isLoading = false,
  });

  final bool showLoginForm;
  final bool isLoading;

  @override
  List<Object> get props => [
        showLoginForm,
        isLoading,
      ];

  LoginState copyWith({
    bool? showLoginForm,
    bool? isLoading,
  }) {
    return LoginState(
      showLoginForm: showLoginForm ?? this.showLoginForm,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
