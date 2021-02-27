import 'package:allocrepes/allo/oder_new/view/order_new_page.dart';
import 'package:allocrepes/allo/order_list/cubit/order_list_cubit.dart';
import 'package:allocrepes/allo/order_list/cubit/order_list_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/order.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes commandes"),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: theme.primaryColorDark,
          onPressed: () {
            Navigator.push(context, OrderNewPage.route());
          },
          child: const Icon(Icons.shopping_cart),
          tooltip: "Commander",
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Text(
              "Mes commandes en cours",
              style: textTheme.headline5,
            ),
          ),
          BlocBuilder<OrderListCubit, OrderListState>(
            buildWhen: (prev, next) => prev.currentOrders != next.currentOrders,
            builder: (BuildContext context, OrderListState state) {
              if (state.currentOrders.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        const TextSpan(
                            text:
                                "Commandez dès maintenant en appuyant sur l'icone "),
                        const WidgetSpan(
                          child: const Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: const Icon(Icons.shopping_cart),
                          ),
                        ),
                        const TextSpan(text: "en bas à droite"),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: state.currentOrders
                    .map<_OrderSummary>((e) => _OrderSummary(order: e))
                    .toList(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Text(
              "Mes commandes passées",
              style: textTheme.headline5,
            ),
          ),
          BlocBuilder<OrderListCubit, OrderListState>(
            buildWhen: (prev, next) =>
                prev.previousOrders != next.previousOrders,
            builder: (BuildContext context, OrderListState state) {
              return Column(
                children: state.previousOrders
                    .map<_OrderSummary>((e) => _OrderSummary(order: e))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final Order order;

  const _OrderSummary({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Commande n°${order.id}",
              style: theme.textTheme.headline6,
            ),
            Text(
                "Commandé le ${order.createdAt?.toLocal().toString().split(".")[0]}"),
            Text("Livraison à ${order.place}, salle/appartement ${order.room}"),
            _OrderSummaryStatus(order.status),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.articles.map((Article a) {
                  return Text("${a.amount.toString()}x ${a.product.name}");
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryStatus extends StatelessWidget {
  final OrderStatus status;

  const _OrderSummaryStatus(this.status, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyText1;

    switch (status) {
      case OrderStatus.CANCELED:
        return Text(
          "Annulé",
          style: textTheme.merge(TextStyle(color: Colors.red)),
        );
        break;
      case OrderStatus.PENDING:
        return Text(
          "En cours de préparation",
          style: textTheme.merge(TextStyle(color: Colors.amber)),
        );
        break;
      case OrderStatus.DELIVERING:
        return Text(
          "En cours de livraison",
          style: textTheme.merge(TextStyle(color: Colors.amber)),
        );
        break;
      case OrderStatus.DELIVERED:
        return Text(
          "Livrée",
          style: textTheme.merge(TextStyle(color: Colors.green)),
        );
        break;
      default:
        return Text(
          "Etat inconnu",
          style: textTheme.merge(TextStyle(color: Colors.grey)),
        );
        break;
    }
  }
}
