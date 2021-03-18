import 'package:allocrepes/allo/product_list/cubit/product_list_cubit.dart';
import 'package:allocrepes/allo/product_list/cubit/product_list_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class ProductListView extends StatelessWidget {
  const ProductListView() : super();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: [
          BlocBuilder<ProductListCubit, ProductListState>(
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
            width: double.infinity,
            child: FlatButton(
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

class _ProductEntry extends StatelessWidget {
  final Product product;
  final Category category;

  const _ProductEntry({
    Key? key,
    required this.product,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dismissible(
      key: Key("${category.id};${product.id}"),
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
      onDismissed: (direction) => BlocProvider.of<ProductListCubit>(context)
          .removeProduct(category, product),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Image(image: product.image),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 7,
              child: Text(product.name, style: textTheme.headline6),
            ),
            Checkbox(
              value: product.available,
              onChanged: (bool? availability) =>
                  BlocProvider.of<ProductListCubit>(context)
                      .updateProductAvailability(
                          category, product, availability ?? false),
            ),
          ],
        ),
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
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => BlocProvider.of<ProductListCubit>(context)
                        .editCategoryDialog(context, category),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => BlocProvider.of<ProductListCubit>(context)
                        .deleteCategoryDialog(context, category),
                  )
                ],
              ),
              Column(
                children: products
                    .map<_ProductEntry>((product) => _ProductEntry(
                          product: product,
                          category: category,
                        ))
                    .toList(),
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
