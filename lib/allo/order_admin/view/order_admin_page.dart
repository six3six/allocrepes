import 'package:allocrepes/allo/order_admin/cubit/order_admin_cubit.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'order_admin_view.dart';

class OrderAdminPage extends StatelessWidget {
  static Route route({
    bool? fast,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => OrderAdminPage(
        fast: fast ?? false,
      ),
      settings: const RouteSettings(name: 'OrderAdmin'),
    );
  }

  const OrderAdminPage({
    Key? key,
    this.fast = false,
  }) : super(key: key);
  final bool fast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        return BlocProvider<OrderAdminCubit>(
          create: (context) => OrderAdminCubit(
            RepositoryProvider.of<AuthenticationRepository>(context),
            RepositoryProvider.of<OrderRepositoryFirestore>(context),
            fast,
          ),
          child: const OrderAdminView(),
        );
      },
    );
  }
}
