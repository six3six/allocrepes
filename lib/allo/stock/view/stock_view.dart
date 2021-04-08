import 'package:allocrepes/allo/stock/cubit/stock_cubit.dart';
import 'package:allocrepes/allo/stock/cubit/stock_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class StockView extends StatelessWidget {
  const StockView() : super();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stocks"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: [
          BlocBuilder<StockCubit, StockState>(
            buildWhen: (prev, next) =>
                prev.categories.keys.toList() !=
                    next.categories.keys.toList() ||
                prev.categories.values.toList() !=
                    next.categories.values.toList(),
            builder: (context, state) {
              List<_ProductCategory> categories = [];
              state.categories.forEach((Category cat, List<Product> products) =>
                  categories.add(
                      _ProductCategory(category: cat, products: products)));

              return Column(
                children: categories,
              );
            },
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<StockCubit>(context).removeOrders(),
              child: Text("Supprimer TOUTES les commandes"),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockEntry extends StatelessWidget {
  final Product product;
  final Category category;

  _StockEntry({
    Key? key,
    required this.product,
    required this.category,
  }) : super(key: key);

  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    quantityController..text = product.initialStock.toString();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 7,
                child: Text(product.name, style: textTheme.headline6),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 7,
                child: Text(
                  "Stock initial",
                ),
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: quantityController,
                  onChanged: (val) {
                    BlocProvider.of<StockCubit>(context).updateProductMaxAmount(
                        category, product, int.tryParse(val) ?? 0);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 7,
                child: Text(
                  "Consommé",
                ),
              ),
              Expanded(
                flex: 3,
                child: BlocBuilder<StockCubit, StockState>(
                  buildWhen: (prev, next) =>
                      prev.count[product.id] != next.count[product.id],
                  builder: (context, state) =>
                      Text((state.count[product.id] ?? 0).toString()),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 7,
                child: Text(
                  "Restant",
                ),
              ),
              Expanded(
                flex: 3,
                child: BlocBuilder<StockCubit, StockState>(
                  buildWhen: (prev, next) =>
                      prev.count[product.id] != next.count[product.id],
                  builder: (context, state) {
                    final rest =
                        (product.initialStock - (state.count[product.id] ?? 0));

                    return Text(
                      rest.toString(),
                      style: TextStyle(
                          color: rest > 0 ? Colors.green : Colors.red),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCategory extends StatelessWidget {
  final List<Product> products;
  final Category category;

  const _ProductCategory(
      {Key? key, required this.category, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20)
              .add(EdgeInsets.only(top: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: textTheme.headline5,
                    ),
                  ),
                ],
              ),
              Column(
                children: products
                    .map<_StockEntry>((product) => _StockEntry(
                          product: product,
                          category: category,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
