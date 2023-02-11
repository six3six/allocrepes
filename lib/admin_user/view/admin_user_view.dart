import 'package:allocrepes/admin_user/cubit/admin_user_cubit.dart';
import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
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
              _ClsSelector(),
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

    return ExpansionTile(
      title: Text('Filtres'),
      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom de famille :',
          style: theme.textTheme.caption,
        ),
        TextField(
          onChanged: (value) {
            BlocProvider.of<AdminUserCubit>(context)
                .updateUserQuery(username: value);
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Trié par :',
          style: theme.textTheme.caption,
        ),
        BlocBuilder<AdminUserCubit, AdminUserState>(
          buildWhen: (prev, next) => prev.sortUser != next.sortUser,
          builder: (context, state) {
            return ExpansionTile(
              title: Text(
                'Trié par : ',
              ),
              children: [
                ListTile(
                  title: Text('Par identifiant'),
                  leading: Radio<SortUser>(
                    value: SortUser.Name,
                    groupValue: state.sortUser,
                    onChanged: (value) =>
                        BlocProvider.of<AdminUserCubit>(context)
                            .updateUserQuery(sortUser: value),
                  ),
                ),
                ListTile(
                  title: Text('Par points'),
                  leading: Radio<SortUser>(
                    value: SortUser.Point,
                    groupValue: state.sortUser,
                    onChanged: (value) =>
                        BlocProvider.of<AdminUserCubit>(context)
                            .updateUserQuery(sortUser: value),
                  ),
                ),
              ],
            );
          },
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
    return BlocBuilder<AdminUserCubit, AdminUserState>(
      buildWhen: (prev, next) =>
          !IterableEquality().equals(prev.users.keys, next.users.keys),
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: state.users.keys.map((e) => _UserTile(id: e)).toList(),
        );
      },
    );
  }
}

class _UserTile extends StatelessWidget {
  final String id;

  _UserTile({
    Key? key,
    required this.id,
  }) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AdminUserCubit, AdminUserState>(
      builder: (context, state) {
        if (state.users[id] == null) return SizedBox();
        var user = state.users[id] ?? User.empty;

        return ExpansionTile(
          title: Text('${user.id} : ${user.surname} ${user.name}'),
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prenom:',
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: surnameController..text = user.surname,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Nom:',
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: nameController..text = user.name,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Email:',
              style: theme.textTheme.caption,
            ),
            TextField(
              controller: emailController..text = user.email,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Points:',
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
              title: Text('Admin'),
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
                      child: Text('Valider'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () =>
                        BlocProvider.of<AdminUserCubit>(context).removeUser(id),
                    child: Text('Supprimer'),
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

class _ClsSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  'Activer l\'affichage des classements sur la page principal (à utiliser avec précaution)',
                ),
              ),
              Expanded(
                flex: 2,
                child: BlocBuilder<AdminUserCubit, AdminUserState>(
                  buildWhen: (prev, next) => prev.showCls != next.showCls,
                  builder: (context, state) => Checkbox(
                    value: state.showCls,
                    onChanged: (bool? enable) =>
                        BlocProvider.of<AdminUserCubit>(context)
                            .changeClsView(enable ?? false),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
