import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Bienvenue sur l'application Xanthos !",
          style: textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          "C'est ici que l'aventure commence",
          style: textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 60,
        ),
        SizedBox.fromSize(
          size: Size(80, 80), // button width and height
          child: ClipOval(
            child: Material(
              color: theme.primaryColor,
              elevation: 100,
              child: InkWell(
                splashColor: theme.primaryColorDark, // splash color
                onTap: () => BlocProvider.of<LoginCubit>(context)
                    .showLoginForm(), // button pressed
                child: Icon(
                  Icons.navigate_next,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
