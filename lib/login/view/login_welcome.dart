import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWelcome extends StatelessWidget {
  const LoginWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      children: <Widget>[
        const SizedBox(height: 40.0),
        Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/logo.png',
              height: 250,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Bienvenue sur l'application Selva !",
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "C'est ici que l'aventure commence",
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "Connectez-vous à votre compte ESIEE",
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60,
            ),
            FilledButton(
              onPressed: () =>
                  BlocProvider.of<LoginCubit>(context)
                      .showLoginForm(),
              child: const Text(
                'Je suis de l\'ESIEE',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('ou', style: textTheme.headlineLarge,),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () =>
                  BlocProvider.of<LoginCubit>(context)
                      .showESIPEForm(context),
              child: const Text(
                'Je suis de l\'ex-ESIPE',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
