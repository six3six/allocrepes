import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/view/lobby_about.dart';
import 'package:allocrepes/lobby/view/lobby_view.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => LobbyPage(),
      settings: RouteSettings(name: 'Main'),
    );
  }

  const LobbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XANTHOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.run_circle_outlined),
            tooltip: 'Se deconnecter',
            onPressed: () =>
                RepositoryProvider.of<AuthenticationRepository>(context)
                    .logOut(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'A propos',
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => LobbyAbout(),
              );
            },
          ),
        ],
      ),
      body: LobbyView(),
    );
  }
}
