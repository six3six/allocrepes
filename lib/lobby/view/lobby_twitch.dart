import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LobbyTwitchViewer extends StatefulWidget {
  @override
  LobbyTwitchViewerState createState() => LobbyTwitchViewerState();
}

class LobbyTwitchViewerState extends State<LobbyTwitchViewer> {
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
    return WebView(
      debuggingEnabled: false,
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:
          'https://player.twitch.tv/?channel=ponce&muted=true&parent=xanthos.fr',
      gestureNavigationEnabled: true,
      navigationDelegate: (NavigationRequest request) async {
        if (request.url.startsWith("https://player.twitch.tv"))
          return NavigationDecision.navigate;
        else {
          try {
            launch(request.url);
          } catch (e) {}
          return NavigationDecision.prevent;
        }
      },
    );
  }
}
