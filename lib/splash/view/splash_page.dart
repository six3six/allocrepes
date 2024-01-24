import 'package:flutter/material.dart';

/// Splashscreen class
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
