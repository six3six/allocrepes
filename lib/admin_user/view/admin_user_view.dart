import 'package:flutter/material.dart';

class AdminUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Utilisateurs"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              _FilterView(),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterView extends StatelessWidget {
  const _FilterView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ExpansionTile(
      title: Text("Filtres"),
      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nom d'utilisateur :",
          style: theme.textTheme.caption,
        ),
        TextField(),
        Text(
          "Trié par :",
          style: theme.textTheme.caption,
        ),
        ExpansionTile(
          title: Text("Trié par : "),
          children: [],
        ),
      ],
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [],
    );
  }
}
