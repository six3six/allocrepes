import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  static final ssoUrl = Uri.https('sso.esiee.fr', '/cas/login', {
    'service':
        'https://us-central1-allocrepes-4f992.cloudfunctions.net/ssoLogin/'
  });

  Future<void> showLoginForm() async {
    print(ssoUrl.toString());

    final result = await FlutterWebAuth.authenticate(
        url: ssoUrl.toString(), callbackUrlScheme: "allocrepes-auth");

    final token = Uri.parse(result).queryParameters['token'];

    if (token != null) {
      await _authenticationRepository.logInWithToken(token: token);
    }
  }
}
