import 'package:allocrepes/allo/oder_new/view/order_new_page.dart';
import 'package:allocrepes/allo/order_list/cubit/order_list_cubit.dart';
import 'package:allocrepes/allo/order_list/cubit/order_list_state.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/cubit/lobby_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'order_list_view.dart';

class OrderListPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => OrderListPage(),
      settings: RouteSettings(name: 'OrderList'),
    );
  }

  const OrderListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes'),
      ),
      floatingActionButton: BlocBuilder<LobbyCubit, LobbyState>(
        buildWhen: (prev, next) => prev.showOrder != next.showOrder,
        builder: (context, state) {
          if (!state.showOrder) {
            return FloatingActionButton.extended(
              label: const Text('Commandes indisponibles'),
              icon: const Icon(Icons.remove_shopping_cart_outlined),
              backgroundColor: Colors.grey,
              foregroundColor: Colors.black,
              onPressed: null,
            );
          }
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(OrderNewPage.route());
            },
            label: const Text('Commander'),
            icon: const Icon(Icons.add_shopping_cart),
          );
        },
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          return BlocProvider<OrderListCubit>(
            create: (context) => OrderListCubit(
              RepositoryProvider.of<OrderRepositoryFirestore>(context),
            ),
            child: BlocBuilder<OrderListCubit, OrderListState>(
              buildWhen: (prev, next) =>
                  prev.isLoading != next.isLoading ||
                  prev.isConnected != next.isConnected,
              builder: (context, state) => LoadingOverlay(
                isLoading: state.isLoading || !state.isConnected,
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
                    if (!state.isConnected)
                      Text(
                        'En attente de connexion...',
                        style: theme.textTheme.titleLarge,
                      ),
                  ],
                ),
                child: const OrderListView(),
              ),
            ),
          );
        },
      ),
    );
  }
}
