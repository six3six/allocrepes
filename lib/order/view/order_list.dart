import 'package:flutter/material.dart';
import 'package:order_repository/models/order.dart';

class OrderList extends StatelessWidget {
  const OrderList({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final List<Order> orders = [
      Order(
          status: OrderStatus.PENDING,
          createdAt: DateTime.now(),
          id: "2132132132",
          articles: []),
      Order(
          status: OrderStatus.DELIVERED,
          createdAt: DateTime.now(),
          id: "12123",
          articles: []),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes commandes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.shopping_cart),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Text(
              "Mes commandes en cours",
              style: textTheme.headline5,
            ),
          ),
        ]
          ..addAll(orders.map<OrderSummary>((e) => OrderSummary(order: e)))
          ..add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Text(
                "Mes commandes terminées",
                style: textTheme.headline5,
              ),
            ),
          )
          ..addAll(orders.map<OrderSummary>((e) => OrderSummary(order: e))),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final Order order;

  const OrderSummary({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Commande n°${order.id}",
              style: theme.textTheme.headline6,
            ),
            Text("Commandé le ${order.createdAt?.toString()}"),
            _OrderSummaryStatus(order.status),
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
