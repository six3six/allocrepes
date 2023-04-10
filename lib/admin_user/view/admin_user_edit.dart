import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/admin_user_cubit.dart';

class AdminUserEdit extends StatefulWidget {
  final User user;

  AdminUserEdit({super.key, required this.user});

  static Route route(User user, AdminUserCubit adminUserCubit) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<AdminUserCubit>(
        create: (context) => adminUserCubit,
        child: AdminUserEdit(user: user),
      ),
      settings: RouteSettings(name: 'AdminUserEdit'),
    );
  }


  @override
  State<AdminUserEdit> createState() => AdminUserEditState();
}

class AdminUserEditState extends State<AdminUserEdit> {
  late bool _admin;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();


  @override
  void initState() {
    _admin = widget.user.admin;
    _surnameController.text = widget.user.surname;
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _pointsController.text = widget.user.point.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editer un utilisateur'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prenom:',
              style: theme.textTheme.bodySmall,
            ),
            TextField(
              controller: _surnameController,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Nom:',
              style: theme.textTheme.bodySmall,
            ),
            TextField(
              controller: _nameController,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Email:',
              style: theme.textTheme.bodySmall,
            ),
            TextField(
              controller: _emailController,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Points:',
              style: theme.textTheme.bodySmall,
            ),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 5,
            ),
            CheckboxListTile(
              title: Text('Admin'),
              value: _admin,
              onChanged: (va) => setState(() {
                _admin = va ?? false;
              }),
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        final _user = widget.user.copyWith(
                          surname: _surnameController.text,
                          name: _nameController.text,
                          email: _emailController.text,
                          point:
                              int.tryParse(_pointsController.text) ?? 0,
                          admin: _admin,
                        );
                        BlocProvider.of<AdminUserCubit>(context)
                            .updateUser(_user);
                        Navigator.of(context).pop();
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
                    onPressed: () {
                      BlocProvider.of<AdminUserCubit>(context)
                          .removeUser(widget.user.id);
                      Navigator.of(context).pop();
                    },
                    child: Text('Supprimer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
