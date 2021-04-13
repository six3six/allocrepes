import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  Text("Fait avec le ❤"),
                  Text("par Louis DESPLANCHE"),
                ],
              ),
            if (easter)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fait avec le cul"),
                  Text("par Louis DESPLANCHE"),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            Text("Aucun test n'a été dev pour ce projet"),
            Text(
              "Tester c'est douter",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 20,
            ),
            Text("© Liste BDE ESIEE Paris 2021-2022"),
            SizedBox(
              height: 20,
            ),
            if (easter)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nique tous ces RG",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("Théo, 2021"),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (conext, snapshot) {
                if (snapshot.hasData) {
                  PackageInfo infos = snapshot.data! as PackageInfo;

                  return Text(
                    "Version : ${infos.version} build ${infos.buildNumber}",
                    style: textTheme.overline,
                  );
                } else
                  return SizedBox();
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Ok, je m'en fiche"),
          onLongPress: () => setState(() {
            easter = true;
          }),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
