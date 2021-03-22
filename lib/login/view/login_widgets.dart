import 'dart:async';
import 'dart:io';

import 'package:allocrepes/login/cubit/login_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'login_theme.dart';

class AuthWebView extends StatefulWidget {
  @override
  AuthWebViewState createState() => AuthWebViewState();
}

class AuthWebViewState extends State<AuthWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    CookieManager().clearCookies();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Text(
          "Impossible de se connecter pour l'instant sur la plateforme web");
    }
    return WebView(
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:
          'https://sso.esiee.fr/cas/login?service=https%3A%2F%2Fus-central1-allocrepes-4f992.cloudfunctions.net%2FssoLogin/',
      gestureNavigationEnabled: true,
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith(
            'https://us-central1-allocrepes-4f992.cloudfunctions.net/ssoLogin/')) {
          BlocProvider.of<LoginCubit>(context).login(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
  }
}
