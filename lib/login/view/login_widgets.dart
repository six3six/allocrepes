import 'dart:io';

import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'login_theme.dart';

class AuthWebView extends StatefulWidget {
  @override
  AuthWebViewState createState() => AuthWebViewState();
}

class AuthWebViewState extends State<AuthWebView> {
  late final controller;

  static const sso_url = 'https://sso.esiee.fr/cas/login?service=https%3A%2F%2Fus-central1-allocrepes-4f992.cloudfunctions.net%2FssoLogin/';

  @override
  void initState() {
    super.initState();
    WebViewCookieManager().clearCookies();

    controller = WebViewController()
      ..loadRequest(Uri.parse(sso_url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
              'https://us-central1-allocrepes-4f992.cloudfunctions.net/ssoLogin',
            )) {
              BlocProvider.of<LoginCubit>(context).login(request.url);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Text(
        "Impossible de se connecter pour l'instant sur la plateforme web",
      );
    }

    return WebViewWidget(controller: controller);
  }
}

class AuthTokenView extends StatelessWidget {
  final TextEditingController tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pour se connecter, appuyez sur le bouton ci-dessous. Puis copier coller le code dans le champs \"Token\"',
        ),
        TextButton(
          onPressed: () => launch(
            'https://sso.esiee.fr/cas/login?service=https%3A%2F%2Fus-central1-allocrepes-4f992.cloudfunctions.net%2FssoLoginToken/',
          ),
          child: Text('Obtenir un token'),
        ),
        SizedBox(
          height: 15,
        ),
        Text('Token : '),
        TextField(
          controller: tokenController,
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () => BlocProvider.of<LoginCubit>(context)
              .loginWithToken(tokenController.text),
          child: Text('Valider'),
        ),
      ],
    );
  }
}
