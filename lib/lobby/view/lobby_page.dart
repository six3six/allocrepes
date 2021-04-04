import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/view/lobby_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lobby_twitch.dart';

class LobbyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => LobbyPage(),
      settings: RouteSettings(name: "Main"),
    );
  }

  const LobbyPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("XANTHOS"),
      ),
      body: BlocProvider<LobbyCubit>(
        create: (context) => LobbyCubit(),
        child: LobbyView(),
      ),
    );
  }
}
