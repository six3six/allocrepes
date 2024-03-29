import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:allocrepes/login/cubit/login_state.dart';
import 'package:allocrepes/login/view/login_welcome.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoginPage(),
      settings: const RouteSettings(name: 'Login'),
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
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            child: const LoginWelcome(),
          ),
        ),
      ),
    );
  }
}
