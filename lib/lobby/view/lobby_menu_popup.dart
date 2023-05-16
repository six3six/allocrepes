import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lobby_about.dart';

class LobbyMenuPopup extends StatelessWidget {
  static double popupRadius = 15;

  const LobbyMenuPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthenticationBloc>(context).state.user;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(popupRadius),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vous êtes connecté en tant que :'),
              Text(
                '${user.surname} ${user.name.toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.run_circle_outlined),
            title: const Text('Se deconnecter'),
            onTap: () =>
                RepositoryProvider.of<AuthenticationRepository>(context)
                    .logOut(),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('A propos'),
            onTap: () => showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => const LobbyAbout(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.flutter_dash),
            title: const Text('Afficher les Licences'),
            onTap: () => showLicensePage(
              context: context,
              applicationIcon: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Annuler"),
        ),
      ],
    );
  }
}
