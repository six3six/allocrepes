import 'package:allocrepes/allo/oder_new/cubit/order_new_cubit.dart';
import 'package:allocrepes/allo/oder_new/cubit/order_new_state.dart';
import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository_firestore.dart';

class OrderNewView extends StatelessWidget {
  const OrderNewView({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes commandes"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<OrderNewCubit, OrderNewState>(
                  buildWhen: (prev, next) => prev.placeError != next.placeError,
                  builder: (context, state) => Text(
                    state.placeError,
                    style: theme.textTheme.bodyText2!
                        .merge(TextStyle(color: Colors.red)),
                  ),
                ),
                Text(
                  "Batiment : ",
                  style: theme.textTheme.caption,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: BlocBuilder<OrderNewCubit, OrderNewState>(
                    buildWhen: (prev, next) => prev.place != next.place,
                    builder: (context, state) => DropdownButton<Place>(
                      value: state.place,
                      onChanged: (Place? place) =>
                          BlocProvider.of<OrderNewCubit>(context)
                              .updatePlace(place),
                      items: Place.values
                          .map<DropdownMenuItem<Place>>((Place place) {
                        return DropdownMenuItem<Place>(
                          value: place,
                          child: Text(PlaceUtils.placeToString(place)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                BlocBuilder<OrderNewCubit, OrderNewState>(
                  buildWhen: (prev, next) => prev.roomError != next.roomError,
                  builder: (context, state) => Text(
                    state.roomError,
                    style: theme.textTheme.bodyText2!
                        .merge(TextStyle(color: Colors.red)),
                  ),
                ),
                TextField(
                  onChanged: (val) =>
                      BlocProvider.of<OrderNewCubit>(context).updateRoom(val),
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Appart n°',
                    helperText: '',
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<OrderNewCubit, OrderNewState>(
            buildWhen: (prev, next) =>
                prev.categories.keys != next.categories.keys ||
                prev.categories.values.toList() !=
                    next.categories.values.toList(),
            builder: (context, state) {
              List<_OrderNewCategory> categories = [];
              state.categories.forEach((Category cat, List<Product> products) =>
                  categories.add(
                      _OrderNewCategory(category: cat, products: products)));

              return Column(
                children: categories,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<OrderNewCubit>(context)
                      .checkout(context)
                      .then((ok) {
                    if (ok)
                      Navigator.pushReplacement(context, OrderListPage.route());
                  });
                },
                child: Text("Commander"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderNewCategory extends StatelessWidget {
  final Category category;
  final List<Product> products;

  const _OrderNewCategory(
      {Key? key, required this.category, required this.products})
      : super(key: key);

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
                category.name,
                style: textTheme.headline5,
              ),
              Column(
                children: products
                    .map<_OrderNewItem>((product) =>
                        _OrderNewItem(category: category, product: product))
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

class _OrderNewItem extends StatelessWidget {
  final Category category;
  final Product product;

  const _OrderNewItem({Key? key, required this.category, required this.product})
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
          Expanded(
            flex: 7,
            child: Text(product.name, style: textTheme.headline5),
          ),
          DropdownButton<int>(
            value: BlocProvider.of<OrderNewCubit>(context)
                .getQuantity(category, product),
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
            iconSize: 24,
            elevation: 16,
            onChanged: (int? val) => BlocProvider.of<OrderNewCubit>(context)
                .updateQuantity(category, product, val ?? 0),
            items: <int>[0, 1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(" " + value.toString() + " "),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
