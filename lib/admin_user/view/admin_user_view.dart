import 'package:allocrepes/admin_user/cubit/admin_user_cubit.dart';
import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:collection/collection.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
      ),
      body: Column(
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
          style: theme.textTheme.bodySmall,
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
          style: theme.textTheme.bodySmall,
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
    return Expanded(
      child: BlocBuilder<AdminUserCubit, AdminUserState>(
        buildWhen: (prev, next) =>
            prev.sortUser != next.sortUser ||
            prev.usernameQuery != next.usernameQuery,
        builder: (context, state) {
          print("REVZDQDQZDQZD");
          return FirestoreListView<User>(
            query: RepositoryProvider.of<AuthenticationRepository>(context)
                .getUsersQuery(
              usernameSearch: state.usernameQuery,
              sort: state.sortUser,
            ),
            itemBuilder: (context, snapshot) {
              return _UserTile(
                user: snapshot.data(),
                onUpdate: (user) {
                  BlocProvider.of<AdminUserCubit>(context).updateUser(user);
                },
                onRemove: (user) {
                  BlocProvider.of<AdminUserCubit>(context).removeUser(user.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;
  final Function(User) onRemove;

  _UserTile({
    Key? key,
    required this.user,
    required this.onUpdate,
    required this.onRemove,
  }) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: ExpansionTile(
        title: Text('${user.id} : ${user.surname} ${user.name}'),
        //childrenPadding: EdgeInsets.symmetric(horizontal: 10),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prenom:',
            style: theme.textTheme.bodySmall,
          ),
          TextField(
            controller: surnameController..text = user.surname,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Nom:',
            style: theme.textTheme.bodySmall,
          ),
          TextField(
            controller: nameController..text = user.name,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Email:',
            style: theme.textTheme.bodySmall,
          ),
          TextField(
            controller: emailController..text = user.email,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Points:',
            style: theme.textTheme.bodySmall,
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
            value: user.admin,
            onChanged: (va) {
              onUpdate(user);
            },
          ),
          Center(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final _user = user.copyWith(
                        surname: surnameController.text,
                        name: nameController.text,
                        email: emailController.text,
                        point: int.tryParse(pointsController.text) ?? 0,
                      );

                      onUpdate(_user);
                    },
                    child: Text('Valider'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () => onRemove(user),
                  child: Text('Supprimer'),
                ),
              ],
            ),
          ),
        ],
      ),
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
