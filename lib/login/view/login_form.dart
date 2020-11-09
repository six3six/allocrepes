import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:allocrepes/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'login_widgets.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key key}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Column(children: <Widget>[
        const SizedBox(height: 60.0),
        GoogleLoginButton(),
        const SizedBox(height: 60.0),
        const SizedBox(height: 10),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) =>
              previous.showSignInWithApple != current.showSignInWithApple,
          builder: (context, LoginState state) {
            return state.showSignInWithApple ? AppleLoginButton() : SizedBox();
          },
        ),
      ]),
    );
  }
}
