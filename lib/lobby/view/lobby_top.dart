import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    //Initial
    /*return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Hero(
            tag: "logo",
            child: Image.asset(
              "assets/logo.png",
              width: 250,
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(0, 30),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) => Text(
                "Bonjour " + state.user.surname,
                style: textTheme.subtitle1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) =>
                  Text("Points : " + state.user.point.toString()),
            ),
            TextButton(
              onPressed: () =>
                  RepositoryProvider.of<AuthenticationRepository>(context)
                      .logOut(),
              child: Text("Se déconnecter"),
            ),
          ],
        ),
      ],
    );*/

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Hero(
                  tag: "logo",
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) => Text(
                      "Bonjour " + state.user.surname,
                      style:
                          textTheme.subtitle1?.merge(TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) => Text(
                      "Points : " + state.user.point.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
