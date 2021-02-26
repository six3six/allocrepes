import 'package:allocrepes/allo/oder_new/cubit/order_new_cubit.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'order_new_view.dart';

class OrderNewPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderNewPage());
  }

  const OrderNewPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OrderRepositoryFirestore(),
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context)),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (BuildContext context, AuthenticationState state) {
          return BlocProvider<OrderNewCubit>(
            create: (context) => OrderNewCubit(
              RepositoryProvider.of<OrderRepositoryFirestore>(context),
              state.user,
            ),
            child: const OrderNewView(),
          );
        }),
      ),
    );
  }
}
