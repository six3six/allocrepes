import 'package:allocrepes/admin_user/cubit/admin_user_cubit.dart';
import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'admin_user_view.dart';

class AdminUserPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => AdminUserPage(),
      settings: RouteSettings(name: 'AdminUser'),
    );
  }

  const AdminUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<AdminUserCubit>(
      create: (context) => AdminUserCubit(
        RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: BlocBuilder<AdminUserCubit, AdminUserState>(
        buildWhen: (prev, next) => prev.isLoading != next.isLoading,
        builder: (context, state) => LoadingOverlay(
          isLoading: state.isLoading,
          color: theme.primaryColor,
          progressIndicator: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Chargement...',
                style: theme.textTheme.headline6,
              ),
            ],
          ),
          child: AdminUserView(),
        ),
      ),
    );
  }
}
