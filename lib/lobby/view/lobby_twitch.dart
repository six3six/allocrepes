import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LobbyTwitchViewer extends StatefulWidget {
  @override
  LobbyTwitchViewerState createState() => LobbyTwitchViewerState();
}

class LobbyTwitchViewerState extends State<LobbyTwitchViewer> {
  late final controller;

  @override
  void initState() {
    super.initState();
    WebViewCookieManager().clearCookies();

    controller = WebViewController()
      ..loadRequest(Uri.parse(
          'https://player.twitch.tv/?channel=listexanthos&muted=true&parent=xanthos.fr'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            print(request.url);
            if (request.url.startsWith('https://player.twitch.tv')) {
              return NavigationDecision.navigate;
            } else {
              if (request.url.startsWith('https://twitch.tv/listexanthos') ||
                  request.url
                      .startsWith('https://www.twitch.tv/listexanthos')) {
                try {
                  await launch(request.url);
                } catch (e) {}
              }
              return NavigationDecision.prevent;
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}

class LobbyHeadlineViewer extends StatefulWidget {
  final String url;

  const LobbyHeadlineViewer({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  LobbyHeadlineViewerState createState() => LobbyHeadlineViewerState();
}

class LobbyHeadlineViewerState extends State<LobbyHeadlineViewer> {
  late final controller;

  @override
  void initState() {
    super.initState();
    WebViewCookieManager().clearCookies();

    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return widget.url != ''
        ? SizedBox(
            height: 300,
            width: double.infinity,
            child: WebViewWidget(controller: controller),
          )
        : SizedBox();
  }
}
