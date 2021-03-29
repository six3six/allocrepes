import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:allocrepes/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_widgets.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {},
      child: Column(children: <Widget>[
        Text(
          "Pour commencer l'aventure Xanthos entrez vos identifants ESIEE ci-dessous",
        ),
        const SizedBox(height: 5.0),
        Text(
          "Cette page est une page officielle ESIEE, nous ne pouvons à aucun moment voir votre mot de passe",
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
          height: 800,
          child: AuthWebView(),
        ),
      ]),
    );
  }
}
