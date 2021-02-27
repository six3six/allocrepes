import 'package:allocrepes/allo/order_list/cubit/order_list_cubit.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'order_list_view.dart';

class OrderListPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderListPage());
  }

  const OrderListPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RepositoryProvider(
      create: (context) => OrderRepositoryFirestore(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
        return BlocProvider<OrderListCubit>(
          create: (context) => OrderListCubit(
              RepositoryProvider.of<OrderRepositoryFirestore>(context),
              state.user),
          child: const OrderListView(),
        );
      }),
    );
  }
}
