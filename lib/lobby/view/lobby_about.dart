import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LobbyAbout extends StatefulWidget {
  const LobbyAbout({super.key});

  @override
  State<StatefulWidget> createState() {
    return LobbyAboutState();
  }
}

class LobbyAboutState extends State<LobbyAbout> {
  bool easter = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('A propos'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (!easter)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fait en 2021 avec le ❤'),
                  Text('pour le BDE Xanthos'),
                  Text('cette année avec l\'aide de Corentin POUPRY 🏳️‍🌈 + Théo LEFEVRE'),
                ],
              ),
            if (easter)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (conext, snapshot) {
                      if (snapshot.hasData) {
                        final info = snapshot.data!;
                        return Text('Selva les gros losers');
                      }
                      return const SizedBox();
                    },
                  ),
                  const Text('même pas foutu de faire une app eux-mêmes.'),
                  const Text(
                      'De toute facon tout le monde sait que Xanthos est le meilleurs BDE de l\'histoire de l\'école !'),
                  GestureDetector(
                    onTap: () {
                      FirebaseAnalytics.instance.logScreenView(screenName: 'easter_xanthos');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => _LobbyXanthosPhoto(),
                        fullscreenDialog: true,
                      ));
                    },
                    child: Image.asset('assets/this_is_xanthos.jpg'),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('© Louis DESPLANCHE 2021-2023'),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (conext, snapshot) {
                if (snapshot.hasData) {
                  final info = snapshot.data!;

                  return Text(
                    'Version : ${info.version} build ${info.buildNumber}',
                    style: textTheme.bodySmall,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onLongPress: () => setState(() {
            easter = true;
          }),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Ok, je m'en fiche"),
        ),
      ],
    );
  }
}

class _LobbyXanthosPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Container(
          alignment: AlignmentDirectional.center,
          child: Image.asset('assets/this_is_xanthos.jpg'),
        ),
      );
}
