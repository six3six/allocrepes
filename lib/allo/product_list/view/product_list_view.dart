import 'package:allocrepes/allo/product_list/cubit/product_list_cubit.dart';
import 'package:allocrepes/allo/product_list/cubit/product_list_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';

class ProductListView extends StatelessWidget {
  const ProductListView() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits"),
      ),
      body: ListView(
        children: [
          BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (prev, next) => !IterableEquality().equals(
              prev.categories.keys,
              next.categories.keys,
            ),
            builder: (context, state) {
              List<_ProductCategory> categories = [];
              state.categories.keys.forEach(
                (Category cat) => categories.add(
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
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => BlocProvider.of<ProductListCubit>(context)
                  .addCategoryDialog(context),
              child: Text("Ajouter une catégorie"),
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
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => BlocProvider.of<ProductListCubit>(context)
                        .editCategoryDialog(context, category),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
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
                  child: Text("Ajouter un produit"),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class _ProductEntry extends StatelessWidget {
  final int rank;
  final Category category;

  _ProductEntry({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProductListCubit, ProductListState>(
      buildWhen: (prev, next) =>
          prev.getProduct(category, rank).id !=
              next.getProduct(category, rank).id ||
          prev.getProduct(category, rank).name !=
              next.getProduct(category, rank).name,
      builder: (context, state) {
        final productId = state.getProduct(category, rank).id ?? "";
        final productName = state.getProduct(category, rank).name;

        return Dismissible(
          key: Key("${category.id};$productId"),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: Align(
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
            productName,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                _ProductAvailability(
                  rank: rank,
                  category: category,
                ),
                _ProductMaxQuantity(
                  rank: rank,
                  category: category,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductAvailability extends StatelessWidget {
  final int rank;
  final Category category;

  const _ProductAvailability({
    Key? key,
    required this.rank,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 7,
          child: BlocBuilder<ProductListCubit, ProductListState>(
            buildWhen: (prev, next) =>
                prev.getProduct(category, rank).name !=
                next.getProduct(category, rank).name,
            builder: (context, state) => Text(
              state.getProduct(category, rank).name,
              style: textTheme.headline6,
            ),
          ),
        ),
        BlocBuilder<ProductListCubit, ProductListState>(
          buildWhen: (prev, next) =>
              prev.getProduct(category, rank) !=
              next.getProduct(category, rank),
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
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 7,
          child: Text(
            "Quantité max",
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
                    "",
                int.tryParse(val) ?? 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
