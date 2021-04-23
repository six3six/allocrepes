import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool enable;

  const MenuCard({
    Key? key,
    this.title = '',
    required this.icon,
    this.onTap,
    this.enable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: ListTile(
          enabled: enable,
          onTap: onTap,
          leading: Icon(
            icon,
          ),
          title: Text(
            title,
          ),
        ),
      ),
    );
    /*
    return SizedBox(
      width: 200,
      height: 200,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );*/
  }
}
