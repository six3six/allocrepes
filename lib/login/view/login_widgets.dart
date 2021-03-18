import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_theme.dart';

class DebugLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        key: const Key('loginForm_appleLogin_raisedButton'),
        label: Text(
          'Pour le debugage : voici une connexion fictive',
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.white),
          softWrap: false,
        ),
        icon: Icon(FontAwesomeIcons.robot, color: Colors.white),
        onPressed: () => context.read<LoginCubit>().loginDebug(),
      ),
    );
  }
}

class TokenLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          label: Text(
            'TOKEN',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
            softWrap: false,
          ),
          icon: Icon(FontAwesomeIcons.robot, color: Colors.white),
          onPressed: () => context.read<LoginCubit>().loginDebug(),
        ),
      ),
    ]);
  }
}
