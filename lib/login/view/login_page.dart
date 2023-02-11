import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:allocrepes/login/cubit/login_state.dart';
import 'package:allocrepes/login/view/login_welcome.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => LoginPage(),
      settings: RouteSettings(name: 'Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => LoginCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        body: BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (prev, next) => prev.isLoading != next.isLoading,
          builder: (context, state) => LoadingOverlay(
            isLoading: state.isLoading,
            color: theme.primaryColor,
            progressIndicator: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Chargement...',
                  style: theme.textTheme.headline6,
                ),
              ],
            ),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.showLoginForm) return LoginForm();

                return LoginWelcome();
              },
            ),
            //child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
