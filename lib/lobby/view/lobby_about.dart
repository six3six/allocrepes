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
                  Text('Fait avec le ❤'),
                  Text('pour le BDE Xanthos'),
                ],
              ),
            if (easter)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fait avec le cul'),
                  Text('par Louis DESPLANCHE'),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            Text("Aucun test n'a été dev pour ce projet"),
            Text(
              "Tester c'est douter",
              style: Theme.of(context).textTheme.bodyLarge,
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
                  var infos = snapshot.data!;

                  return Text(
                    'Version : ${infos.version} build ${infos.buildNumber}',
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
