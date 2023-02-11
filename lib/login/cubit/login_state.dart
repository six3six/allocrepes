import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
  });

  final bool isLoading;

  @override
  List<Object> get props => [
        isLoading,
      ];

  LoginState copyWith({
    bool? showLoginForm,
    bool? isLoading,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
