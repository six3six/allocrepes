import 'package:allocrepes/allo/product_list/cubit/product_list_cubit.dart';
import 'package:allocrepes/allo/product_list/view/product_list_view.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';
import 'package:setting_repository/setting_repository_firestore.dart';

class ProductListPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ProductListPage(),
      settings: const RouteSettings(name: 'AdminProductList'),
    );
  }

  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        return BlocProvider(
          create: (context) => ProductListCubit(
            RepositoryProvider.of<OrderRepositoryFirestore>(context),
            RepositoryProvider.of<SettingRepositoryFirestore>(context),
          ),
          child: const ProductListView(),
        );
      },
    );
  }
}
