import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:allocrepes/login/cubit/login_state.dart';
import 'package:allocrepes/login/view/login_welcome.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => LoginPage(),
      settings: RouteSettings(name: "Login"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          children: <Widget>[
            Center(
              child: Hero(
                tag: "logo",
                child: Image.asset(
                  "assets/logo.png",
                  height: 250,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            BlocProvider(
              create: (_) => LoginCubit(
                context.read<AuthenticationRepository>(),
              ),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  if (state.showLoginForm) return LoginForm();
                  return LoginWelcome();
                },
              ),
              //child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}
