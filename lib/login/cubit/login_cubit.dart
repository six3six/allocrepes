import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import '../view/login_esipe_dialog.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  static final ssoUrl = Uri.https('sso.esiee.fr', '/cas/login', {
    'service': 'https://us-central1-selva-e38bc.cloudfunctions.net/ssoLogin/'
  });

  final sendEmail = FirebaseFunctions.instance.httpsCallable('sendEmail');

  Future<void> showLoginForm() async {
    if (kDebugMode) {
      print(ssoUrl.toString());
    }

    final result = await FlutterWebAuth.authenticate(
        url: ssoUrl.toString(), callbackUrlScheme: "selva-auth");

    final token = Uri.parse(result).queryParameters['token'];

    if (token != null) {
      await _authenticationRepository.logInWithToken(token: token);
    }
  }

  Future<void> showESIPEForm(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: this,
          child: LoginESIPEDialog(),
        );
      },
    );
  }

  Future<void> sendESIPEEmail(String email) async {
    sendEmail(email);
  }

  Future<void> sendESIPEToken(String token) async {
    await _authenticationRepository.logInWithToken(token: token);
  }
}
