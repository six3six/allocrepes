import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const MenuCard({Key key, this.title = "", this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 30.0,
          maxWidth: 30.0,
        ),
        child: Card(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
