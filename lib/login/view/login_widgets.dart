import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_theme.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton.icon(
        key: const Key('loginForm_googleLogin_raisedButton'),
        label: Text(
          'SE CONNECTER AVEC GOOGLE',
          style: TextStyle(color: theme.accentColor),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        icon: Icon(FontAwesomeIcons.google, color: theme.accentColor),
        color: Colors.white,
        onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      ),
    );
  }
}

class AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton.icon(
        key: const Key('loginForm_appleLogin_raisedButton'),
        label: Text(
          'SE CONNECTER AVEC APPLE',
          style: TextStyle(color: Colors.white),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        icon: Icon(FontAwesomeIcons.apple, color: Colors.white),
        color: Colors.black,
        onPressed: () => context.read<LoginCubit>().logInWithApple(),
      ),
    );
  }
}

class DebugLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton.icon(
        key: const Key('loginForm_appleLogin_raisedButton'),
        label: Text(
          'Pour le debugage : voici une connexion fictive',
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.white),
          softWrap: false,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        icon: Icon(FontAwesomeIcons.robot, color: Colors.white),
        color: Colors.green,
        onPressed: () => context.read<LoginCubit>().loginDebug(),
      ),
    );
  }
}
