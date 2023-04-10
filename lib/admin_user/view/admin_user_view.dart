import 'package:allocrepes/admin_user/cubit/admin_user_cubit.dart';
import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:allocrepes/admin_user/view/admin_user_edit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

    return Material(
      elevation: 5,
      child: ExpansionTile(
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
            height: 3,
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
          _ClsSelector(),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  _UserList({
    Key? key,
  }) : super(key: key);
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AdminUserCubit, AdminUserState>(
        buildWhen: (prev, next) =>
            prev.sortUser != next.sortUser ||
            prev.usernameQuery != next.usernameQuery,
        builder: (context, state) {
          final query = RepositoryProvider.of<AuthenticationRepository>(context)
              .getUsersQuery(
            usernameSearch: state.usernameQuery,
            sort: state.sortUser,
          );

          return StreamBuilder(
            stream: query.snapshots(),
            builder: (context, streamSnapshot) {
              if (!streamSnapshot.hasData) return CircularProgressIndicator();
              if ((streamSnapshot.data?.docs.length ?? 0) == 0) {
                return Text('No data');
              }

              return Scrollbar(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: streamSnapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, item) {
                    final user = streamSnapshot.data!.docs[item].data();
                    return ListTile(
                      key: Key('${user.id}-tile'),
                      title: Row(
                        children: [
                          Text('${user.name.toUpperCase()} ${user.surname}'),
                          if (user.admin)
                            Icon(
                              FontAwesomeIcons.crown,
                              size: 15,
                            )
                        ],
                      ),
                      subtitle: Text('${user.point} points'),
                      onTap: () {
                        Navigator.of(context).push(AdminUserEdit.route(
                          user,
                          BlocProvider.of<AdminUserCubit>(context),
                        ));
                      },
                    );
                  },
                ),
              );
            },
          );
        },
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
