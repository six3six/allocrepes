import 'package:allocrepes/allo/oder_new/cubit/order_new_cubit.dart';
import 'package:allocrepes/allo/oder_new/cubit/order_new_state.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'order_new_view.dart';

class OrderNewPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const OrderNewPage(),
      settings: const RouteSettings(name: 'OrderNew'),
    );
  }

  const OrderNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        return BlocProvider<OrderNewCubit>(
          create: (context) => OrderNewCubit(
            RepositoryProvider.of<OrderRepositoryFirestore>(context),
            RepositoryProvider.of<AuthenticationRepository>(context),
            state.user,
          ),
          child: BlocBuilder<OrderNewCubit, OrderNewState>(
            buildWhen: (prev, next) => prev.loading != next.loading,
            builder: (context, state) => LoadingOverlay(
              isLoading: state.loading,
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
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              child: const OrderNewView(),
            ),
          ),
        );
      },
    );
  }
}
