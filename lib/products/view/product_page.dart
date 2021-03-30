import 'package:allocrepes/products/cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';

import 'product_list.dart';

class ProductPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProductPage());
  }

  const ProductPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits"),
      ),
      body: RepositoryProvider(
        create: (BuildContext context) => OrderRepositoryFirestore(),
        child: BlocProvider(
          create: (BuildContext context) =>
              ProductsCubit(context.read<OrderRepositoryFirestore>()),
          child: const ItemList(),
        ),
      ),
    );
  }
}
