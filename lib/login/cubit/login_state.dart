import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({this.showLoginForm = false});

  final bool showLoginForm;

  @override
  List<Object> get props => [showLoginForm];

  LoginState copyWith({
    bool? showLoginForm,
  }) {
    return LoginState(
      showLoginForm: showLoginForm ?? this.showLoginForm,
    );
  }
}
