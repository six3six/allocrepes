import 'package:allocrepes/admin_user/cubit/admin_user_cubit.dart';
import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              Divider(),
              SizedBox(
                height: 10,
              ),
              _UserList(),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterView extends StatelessWidget {

  _FilterView({
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
          "Nom de famille :",
          style: theme.textTheme.caption,
        ),
        TextField(
          onChanged: (value) {
            BlocProvider.of<AdminUserCubit>(context).updateUserQuery(value);
          },

        ),
        SizedBox(
          height: 10,
        ),
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

    return BlocBuilder<AdminUserCubit, AdminUserState>(
        buildWhen: (prev, next) => prev.users.keys != next.users.keys,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.users.keys.map((e) => _UserTile(id: e)).toList(),
          );
        });
  }
}

class _UserTile extends StatelessWidget {
  final String id;

  _UserTile({
    Key? key,
    required this.id,
  }) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocBuilder<AdminUserCubit, AdminUserState>(
      buildWhen: (prev, next) =>
          prev.users[id] != next.users[id] || prev.admin[id] != next.admin[id],
      builder: (context, state) {
        User user = state.users[id] ?? User.empty;
        return ExpansionTile(
          title: Text("${user.id} : ${user.surname} ${user.name}"),
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Prenom:",
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: surnameController..text = user.surname,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Nom:",
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: nameController..text = user.name,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Email:",
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: emailController..text = user.email,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Points:",
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: pointsController..text = user.point.toString(),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 5,
            ),
            CheckboxListTile(
              title: Text("Admin"),
              value: state.admin[id] ?? false,
              onChanged: (va) {
                BlocProvider.of<AdminUserCubit>(context)
                    .changeRole(id, va ?? false);
              },
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<AdminUserCubit>(context).setUserInfo(
                          id,
                          surnameController.text,
                          nameController.text,
                          emailController.text,
                          int.tryParse(pointsController.text) ?? 0,
                        );

                        BlocProvider.of<AdminUserCubit>(context).setUserAdmin(
                          id,
                          state.admin[id] ?? false,
                        );
                      },
                      child: Text("Valider"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Supprimer"),
                    style: TextButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
