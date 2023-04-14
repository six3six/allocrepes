import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LobbyAbout extends StatefulWidget {
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
      title: Text('A propos'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (!easter)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fait en 2021 avec le ❤'),
                  Text('pour le BDE Xanthos'),
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
                        return Text('${info.appName} les gros losers');
                      }
                      return const SizedBox();
                    },
                  ),
                  Text('même pas foutu de faire une app eux-mêmes.'),
                  Text(
                      'De toute facon tout le monde sait que Xanthos est le meilleurs BDE de l\'histoire de l\'école !'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => _LobbyXanthosPhoto(),
                      fullscreenDialog: true,
                    )),
                    child: Image.asset('assets/this_is_xanthos.jpg'),
                  ),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Text('© Louis DESPLANCHE 2021-2023'),
            SizedBox(
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
                  return SizedBox();
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
          child: Text("Ok, je m'en fiche"),
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
