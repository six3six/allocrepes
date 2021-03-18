import 'package:allocrepes/products/cubit/products_cubit.dart';
import 'package:allocrepes/products/cubit/products_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key? key}) : super(key: key);

  _addCategoryDialog(BuildContext context) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Ajouter une categorie"),
        content: TextField(
          controller: controller,
          autocorrect: true,
          decoration: InputDecoration(
            labelText: 'Categorie',
            helperText: 'Crêpes',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Annuler',
              style:
                  theme.textTheme.button!.merge(TextStyle(color: Colors.red)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Ajouter',
              style: theme.textTheme.button!.merge(
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            onPressed: () {
              context.read<ProductsCubit>().addCategory(controller.text);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, ProductsState state) {
          if (state.products == null) return SizedBox();
          List<Widget> catWid = [];

          for (Category category in state.products.keys) {
            catWid.add(_ItemListCategory(
              title: category.name,
              products: state.products[category]!,
              category: category,
            ));
          }

          catWid[catWid.length - 1] = SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlatButton(
                  onPressed: () {
                    _addCategoryDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      Text(
                        "Ajouter une categorie",
                        textAlign: TextAlign.left,
                        style: theme.textTheme.headline5!.merge(
                          TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
          return Column(
            children: catWid,
          );
        }),
      ],
    );
  }
}

class _ItemListCategory extends StatelessWidget {
  final String title;
  final Category category;
  final List<Product> products;

  const _ItemListCategory({
    Key? key,
    required this.title,
    required this.products,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20)
              .add(EdgeInsets.only(top: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headline5!
                    .merge(TextStyle(fontWeight: FontWeight.bold)),
              ),
              Column(
                children: products
                    .map((Product product) => _ItemListTile(
                          image: product.image,
                          product: product,
                          category: category,
                        ))
                    .toList(),
              ),
              Center(
                child: TextButton(
                  onPressed: () => _addProductDialog(
                    context,
                    category,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Expanded(
                        child: Text(
                          "Ajouter un produit",
                          textAlign: TextAlign.center,
                          style: textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  _addProductDialog(BuildContext context, Category category) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Ajouter un produit"),
        content: TextField(
          controller: controller,
          autocorrect: true,
          decoration: InputDecoration(
            labelText: 'Produit',
            helperText: 'Crêpes aux sucres',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Annuler',
              style:
                  theme.textTheme.button!.merge(TextStyle(color: Colors.red)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Ajouter',
              style: theme.textTheme.button!.merge(
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            onPressed: () {
              context
                  .read<ProductsCubit>()
                  .addProduct(category, controller.text);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}

class _ItemListTile extends StatelessWidget {
  final ImageProvider image;
  final Product product;
  final Category category;

  const _ItemListTile(
      {Key? key,
      required this.image,
      required this.product,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Image(
              image: image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 7,
            child: Text(product.name,
                style: product.available
                    ? textTheme.headline5
                    : textTheme.headline5!.merge(TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey))),
          ),
          Checkbox(
            onChanged: (bool? value) => context
                .read<ProductsCubit>()
                .changeAvailability(category, product, value ?? false),
            value: product.available,
          )
        ],
      ),
    );
  }
}
