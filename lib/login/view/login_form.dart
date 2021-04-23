import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'login_widgets.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Text(
            "Pour commencer l'aventure Xanthos entrez vos identifants ESIEE ci-dessous",
          ),
          const SizedBox(height: 5.0),
          Text(
            'Cette page est une page officielle ESIEE, nous ne pouvons à aucun moment voir votre mot de passe',
          ),
          const SizedBox(height: 20.0),
          kIsWeb
              ? AuthTokenView()
              : SizedBox(
                  width: double.infinity,
                  height: 800,
                  child: AuthWebView(),
                ),
          const SizedBox(height: 20.0),
          Text(
            "Vous n'avez pas de compte ESIEE ? Envoyez un mail a louis.desplanche@xanthos.fr",
          ),
        ],
      );
}
