import 'package:allocrepes/allo/stock/cubit/stock_cubit.dart';
import 'package:allocrepes/allo/stock/view/stock_view.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';

class StockPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => StockPage(),
      settings: RouteSettings(name: 'AdminStock'),
    );
  }

  StockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) =>
          BlocProvider(
        create: (context) => StockCubit(
          RepositoryProvider.of<OrderRepositoryFirestore>(
            context,
          ),
        ),
        child: const StockView(),
      ),
    );
  }
}
