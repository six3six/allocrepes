import 'package:allocrepes/allo/stock/cubit/stock_cubit.dart';
import 'package:allocrepes/allo/stock/cubit/stock_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BlocBuilder<StockCubit, StockState>(
              builder: (context, state) {
                var count = 0;
                state.count.forEach((key, value) {
                  count += value;
                });
                return Text('Commande : $count');
              },
            ),
          ),
          BlocBuilder<StockCubit, StockState>(
            buildWhen: (prev, next) => !const IterableEquality().equals(
              prev.categories.keys,
              next.categories.keys,
            ),
            builder: (context, state) {
              var categories = <_ProductCategory>[];
              state.categories.forEach(
                (Category cat, List<Product> products) => categories.add(
                  _ProductCategory(
                    category: cat,
                  ),
                ),
              );
              return Column(
                children: categories,
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<StockCubit>(context).removeOrders(),
              child: const Text('Supprimer TOUTES les commandes'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCategory extends StatelessWidget {
  final Category category;

  const _ProductCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .add(const EdgeInsets.only(top: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              BlocBuilder<StockCubit, StockState>(
                buildWhen: (prev, next) =>
                    (prev.categories[category]?.length ?? 0) !=
                    (next.categories[category]?.length ?? 0),
                builder: (context, state) => Column(
                  children: state.categories[category]
                          ?.map<_StockEntry>((product) => _StockEntry(
                                rank: state.categories[category]
                                        ?.indexOf(product) ??
                                    0,
                                category: category,
                              ))
                          .toList() ??
                      [],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _StockEntry extends StatelessWidget {
  final int rank;
  final Category category;

  const _StockEntry({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<StockCubit, StockState>(
                buildWhen: (prev, next) =>
                    prev.getProduct(category, rank).name !=
                    next.getProduct(category, rank).name,
                builder: (context, state) => Expanded(
                  flex: 7,
                  child: Text(
                    state.getProduct(category, rank).name,
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
          _ProductInitialStock(
            rank: rank,
            category: category,
          ),
          const SizedBox(
            height: 20,
          ),
          _ProductConsumedStock(
            rank: rank,
            category: category,
          ),
          const SizedBox(
            height: 10,
          ),
          _ProductRemainingStock(
            rank: rank,
            category: category,
          ),
        ],
      ),
    );
  }
}

class _ProductInitialStock extends StatelessWidget {
  final TextEditingController quantityController = TextEditingController();
  final int rank;
  final Category category;

  _ProductInitialStock({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockCubit, StockState>(
      buildWhen: (prev, next) =>
          prev.getProduct(category, rank).id !=
          next.getProduct(category, rank).id,
      builder: (context, state) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Expanded(
            flex: 7,
            child: Text(
              'Stock initial',
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: quantityController
                ..text =
                    state.getProduct(category, rank).initialStock.toString(),
              onChanged: (val) {
                BlocProvider.of<StockCubit>(context).updateProductInitialStock(
                  category,
                  state.getProduct(category, rank).id ?? '',
                  int.tryParse(val) ?? 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRemainingStock extends StatelessWidget {
  final int rank;
  final Category category;

  const _ProductRemainingStock({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          flex: 7,
          child: Text(
            'Restant',
          ),
        ),
        Expanded(
          flex: 3,
          child: BlocBuilder<StockCubit, StockState>(
            buildWhen: (prev, next) =>
                prev.count[prev.getProduct(category, rank).id] !=
                    next.count[next.getProduct(category, rank).id] ||
                prev.getProduct(category, rank).initialStock !=
                    next.getProduct(category, rank).initialStock,
            builder: (context, state) {
              final rest = (state.getProduct(category, rank).initialStock -
                  (state.count[state.getProduct(category, rank).id] ?? 0));

              return Text(
                rest.toString(),
                style: TextStyle(
                  color: rest > 0 ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductConsumedStock extends StatelessWidget {
  final int rank;
  final Category category;

  const _ProductConsumedStock({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          flex: 7,
          child: Text(
            'Consommé',
          ),
        ),
        Expanded(
          flex: 3,
          child: BlocBuilder<StockCubit, StockState>(
            buildWhen: (prev, next) =>
                prev.count[prev.getProduct(category, rank).id] !=
                next.count[next.getProduct(category, rank).id],
            builder: (context, state) => Text(
              (state.count[state.getProduct(category, rank).id] ?? 0)
                  .toString(),
            ),
          ),
        ),
      ],
    );
  }
}
