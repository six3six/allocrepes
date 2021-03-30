import 'package:flutter/material.dart';

/// Splashscreen class
class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Hero(
              tag: "logo",
              child: Image.asset(
                "assets/logo.png",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
