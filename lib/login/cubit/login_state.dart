import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isSignIn = true,
    this.showSignInWithApple = false,
    this.status = FormzStatus.pure,
  });

  final bool isSignIn;
  final bool showSignInWithApple;
  final FormzStatus status;

  @override
  List<Object> get props => [isSignIn, showSignInWithApple];

  LoginState copyWith({
    bool isSignIn,
    bool showSignInWithApple,
    FormzStatus status,
  }) {
    return LoginState(
      isSignIn: isSignIn ?? this.isSignIn,
      showSignInWithApple: showSignInWithApple ?? this.showSignInWithApple,
      status: status ?? this.status,
    );
  }
}
