import 'package:allocrepes/products/cubit/products_cubit.dart';
import 'package:allocrepes/products/cubit/products_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              RaisedButton(
                color: theme.primaryColor,
                onPressed: () {},
                child: Text("Ajouter une categorie"),
              ),
              RaisedButton(
                color: theme.primaryColor,
                onPressed: () {},
                child: Text("Ajouter un produit"),
              ),
            ],
          ),
        ),
        BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, ProductsState state) {
          if (state.products == null) return SizedBox();
          List<Widget> catWid = List<Widget>(state.products.keys.length);

          int i = 0;
          for (Category category in state.products.keys) {
            catWid[i] = _ItemListCategory(
              title: category.name,
              products: state.products[category],
            );
            i++;
          }
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
  final List<Product> products;

  const _ItemListCategory(
      {Key key, @required this.title, @required this.products})
      : assert(title != null),
        assert(products != null),
        super(key: key);

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
                style: textTheme.headline5,
              ),
              Column(
                children: products
                    .map((Product product) => _ItemListTile(
                        image: product.image, title: product.name))
                    .toList(),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class _ItemListTile extends StatelessWidget {
  final ImageProvider image;
  final String title;

  const _ItemListTile({Key key, @required this.image, @required this.title})
      : assert(image != null),
        assert(title != null),
        super(key: key);

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
            child: Text(title, style: textTheme.headline5),
          ),
        ],
      ),
    );
  }
}
