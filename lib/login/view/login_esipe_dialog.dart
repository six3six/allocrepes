import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginESIPEDialog extends StatelessWidget {
  final emailFieldController = TextEditingController();
  final tokenFieldController = TextEditingController();

  LoginESIPEDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connexion ex-ESIPE'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'La connexion ESIPE se fait en 2 étapes : \n1. Récuperez votre token de connexion par email\n2. Connectez vous à l\'application',
                    style: textTheme.bodyLarge?.merge(
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Entrez votre mail ESIPE (@edu.univ-eiffel.fr)',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context
                            .read<LoginCubit>()
                            .sendESIPEEmail(emailFieldController.text);
                      },
                      child:
                          const Text('Recevoir le token de connexion par mail'),
                    ),
                  ),
                  const SizedBox(height: 75),
                  Text(
                    'Entrez le code recu par mail',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: tokenFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Token de connexion',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context
                            .read<LoginCubit>()
                            .sendESIPEToken(tokenFieldController.text)
                            .catchError(
                              (e) => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Problème de token'),
                                ),
                              ),
                            );
                      },
                      child: const Text('Se connecter'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
