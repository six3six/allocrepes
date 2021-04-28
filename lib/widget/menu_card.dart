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
  }
}
