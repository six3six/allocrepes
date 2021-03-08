import 'package:allocrepes/allo/order_list/cubit/order_list_cubit.dart';
import 'package:allocrepes/allo/order_list/cubit/order_list_state.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'order_list_view.dart';

class OrderListPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderListPage());
  }

  const OrderListPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepositoryProvider(
      create: (context) => OrderRepositoryFirestore(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
        return BlocProvider<OrderListCubit>(
          create: (context) => OrderListCubit(
              RepositoryProvider.of<OrderRepositoryFirestore>(context),
              state.user),
          child: BlocBuilder<OrderListCubit, OrderListState>(
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
                    "Chargement...",
                    style: theme.textTheme.headline6,
                  ),
                ],
              ),
              child: const OrderListView(),
            ),
          ),
        );
      }),
    );
  }
}
