import 'package:allocrepes/allo/product_list/cubit/product_list_cubit.dart';
import 'package:allocrepes/allo/product_list/cubit/product_list_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
      ),
      body: ListView(
        children: [
          BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (prev, next) => !const IterableEquality().equals(
              prev.categories.keys,
              next.categories.keys,
            ),
            builder: (context, state) {
              var categories = <_ProductCategory>[];
              for (var cat in state.categories.keys) {
                categories.add(
                  _ProductCategory(
                    category: cat,
                  ),
                );
              }

              return Column(
                children: categories,
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => BlocProvider.of<ProductListCubit>(context)
                  .addCategoryDialog(context),
              child: const Text('Ajouter une catégorie'),
            ),
          ),
          _ProductOrderPagesViewCheckbox(),
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
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => BlocProvider.of<ProductListCubit>(context)
                        .editCategoryDialog(context, category),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => BlocProvider.of<ProductListCubit>(context)
                        .deleteCategoryDialog(context, category),
                  ),
                ],
              ),
              BlocBuilder<ProductListCubit, ProductListState>(
                buildWhen: (prev, next) =>
                    (prev.categories[category]?.length ?? 0) !=
                    (next.categories[category]?.length ?? 0),
                builder: (context, state) => Column(
                  children: state.categories[category]
                          ?.map<_ProductEntry>((product) => _ProductEntry(
                                rank: state.categories[category]
                                        ?.indexOf(product) ??
                                    0,
                                category: category,
                              ))
                          .toList() ??
                      [],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => BlocProvider.of<ProductListCubit>(context)
                      .addProductDialog(context, category),
                  child: const Text('Ajouter un produit'),
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

class _ProductEntry extends StatelessWidget {
  final int rank;
  final Category category;

  const _ProductEntry({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      buildWhen: (prev, next) =>
          prev.getProduct(category, rank).id !=
          next.getProduct(category, rank).id,
      builder: (context, state) {
        final productId = state.getProduct(category, rank).id ?? '';

        return Dismissible(
          key: Key('${category.id};$productId'),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          confirmDismiss: (direction) async =>
              await BlocProvider.of<ProductListCubit>(context)
                  .deleteProductDialog(
            context,
            category,
            productId,
          ),
          child: ExpansionTile(
            title: BlocBuilder<ProductListCubit, ProductListState>(
              buildWhen: (prev, next) =>
                  prev.getProduct(category, rank).name !=
                  next.getProduct(category, rank).name,
              builder: (context, state) =>
                  Text(state.getProduct(category, rank).name),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _ProductName(
                      rank: rank,
                      category: category,
                    ),
                    _ProductMaxQuantity(
                      rank: rank,
                      category: category,
                    ),
                    _ProductAvailability(
                      rank: rank,
                      category: category,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductName extends StatelessWidget {
  final int rank;
  final Category category;

  final TextEditingController textEditingController = TextEditingController();

  _ProductName({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 7,
          child: TextField(
            controller: textEditingController
              ..text = BlocProvider.of<ProductListCubit>(context)
                      .state
                      .categories[category]
                      ?.elementAt(rank)
                      .name ??
                  '',
            onChanged: (val) {
              BlocProvider.of<ProductListCubit>(context).updateProductName(
                category,
                BlocProvider.of<ProductListCubit>(context)
                        .state
                        .categories[category]
                        ?.elementAt(rank)
                        .id ??
                    '',
                val,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductMaxQuantity extends StatelessWidget {
  final int rank;
  final Category category;

  _ProductMaxQuantity({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Expanded(
          flex: 7,
          child: Text(
            'Quantité max',
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: quantityController
              ..text = (BlocProvider.of<ProductListCubit>(context)
                          .state
                          .categories[category]
                          ?.elementAt(rank)
                          .maxAmount ??
                      0)
                  .toString(),
            onChanged: (val) {
              BlocProvider.of<ProductListCubit>(context).updateProductMaxAmount(
                category,
                BlocProvider.of<ProductListCubit>(context)
                        .state
                        .categories[category]
                        ?.elementAt(rank)
                        .id ??
                    '',
                int.tryParse(val) ?? 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductAvailability extends StatelessWidget {
  final int rank;
  final Category category;

  _ProductAvailability({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _availableESIEE(),
        _available(),
        _oneOrder(),
      ],
    );
  }

  Widget _availableESIEE() => Row(
        children: [
          const Expanded(
            flex: 7,
            child: Text(
              "Disponible à l'ESIEE",
            ),
          ),
          BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (prev, next) =>
                prev.getProduct(category, rank).availableESIEE !=
                next.getProduct(category, rank).availableESIEE,
            builder: (context, state) => Checkbox(
              value: state.getProduct(category, rank).availableESIEE,
              onChanged: (bool? availability) =>
                  BlocProvider.of<ProductListCubit>(context)
                      .updateProductAvailabilityESIEE(
                category,
                state.getProduct(category, rank),
                availability ?? false,
              ),
            ),
          ),
        ],
      );

  Widget _available() => Row(
        children: [
          const Expanded(
            flex: 7,
            child: Text(
              'Disponible en résidence',
            ),
          ),
          BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (prev, next) =>
                prev.getProduct(category, rank).available !=
                next.getProduct(category, rank).available,
            builder: (context, state) => Checkbox(
              value: state.getProduct(category, rank).available,
              onChanged: (bool? availability) =>
                  BlocProvider.of<ProductListCubit>(context)
                      .updateProductAvailability(
                category,
                state.getProduct(category, rank),
                availability ?? false,
              ),
            ),
          ),
        ],
      );

  Widget _oneOrder() => Row(
        children: [
          const Expanded(
            flex: 7,
            child: Text(
              "Commandable qu'une fois",
            ),
          ),
          BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (prev, next) =>
                prev.getProduct(category, rank).oneOrder !=
                next.getProduct(category, rank).oneOrder,
            builder: (context, state) => Checkbox(
              value: state.getProduct(category, rank).oneOrder,
              onChanged: (bool? availability) =>
                  BlocProvider.of<ProductListCubit>(context)
                      .updateProductOneOrder(
                category,
                state.getProduct(category, rank),
                availability ?? false,
              ),
            ),
          ),
        ],
      );
}

class _ProductOrderPagesViewCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            'Page de commandes',
            style: textTheme.headlineSmall,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Expanded(
                flex: 7,
                child: Text('Activer les pages de commandes'),
              ),
              Expanded(
                flex: 2,
                child: BlocBuilder<ProductListCubit, ProductListState>(
                  buildWhen: (prev, next) =>
                      prev.showOrderPages != next.showOrderPages,
                  builder: (context, state) => Checkbox(
                    value: state.showOrderPages,
                    onChanged: (bool? enable) =>
                        BlocProvider.of<ProductListCubit>(context)
                            .changeOrderPagesView(enable ?? false),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
