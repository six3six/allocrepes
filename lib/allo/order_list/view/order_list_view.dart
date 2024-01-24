import 'package:allocrepes/allo/order_list/cubit/order_list_cubit.dart';
import 'package:allocrepes/allo/order_list/cubit/order_list_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Text(
            'Mes commandes en cours',
            style: textTheme.headlineSmall,
          ),
        ),
        BlocBuilder<OrderListCubit, OrderListState>(
          buildWhen: (prev, next) => !const IterableEquality()
              .equals(prev.currentOrders, next.currentOrders),
          builder: (BuildContext context, OrderListState state) {
            if (state.currentOrders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: const [
                      TextSpan(
                        text:
                            "Commandez dès maintenant en appuyant sur l'icone ",
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(Icons.shopping_cart),
                        ),
                      ),
                      TextSpan(text: 'en bas à droite'),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.currentOrders
                  .map<_OrderSummary>((e) => _OrderSummary(order: e))
                  .toList(),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Text(
            'Mes commandes passées',
            style: textTheme.headlineSmall,
          ),
        ),
        BlocBuilder<OrderListCubit, OrderListState>(
          buildWhen: (prev, next) => !const IterableEquality()
              .equals(prev.previousOrders, next.previousOrders),
          builder: (BuildContext context, OrderListState state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.previousOrders
                  .map<_OrderSummary>((e) => _OrderSummary(order: e))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final Order order;

  const _OrderSummary({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.createdAt.toLocal().toString().split(".")[0].substring(0, 16),
              style: theme.textTheme.titleLarge,
            ),
            Text(
              'Livraison à ${PlaceUtils.placeToString(order.place)}, salle/appartement ${order.room}',
            ),
            _OrderSummaryStatus(order.status),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.articles
                    .map((Article a) => _ArticleToProductLabel(article: a))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleToProductLabel extends StatelessWidget {
  final Article article;

  const _ArticleToProductLabel({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: BlocProvider.of<OrderListCubit>(context).getProduct(article),
      builder: (context, snap) {
        return snap.hasData
            ? Text(
                '${article.amount.toString()}x ${snap.data!.name}',
              )
            : Text(
                '${article.amount.toString()}x ${article.productId}',
              );
      },
    );
  }
}

class _OrderSummaryStatus extends StatelessWidget {
  final OrderStatus status;

  const _OrderSummaryStatus(this.status, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyLarge;

    switch (status) {
      case OrderStatus.CANCELED:
        return Text(
          Order.statusToString(status),
          style: textTheme!.merge(const TextStyle(color: Colors.red)),
        );
      case OrderStatus.VALIDATING:
        return Text(
          Order.statusToString(status),
          style: textTheme!.merge(const TextStyle(color: Colors.grey)),
        );
      case OrderStatus.PENDING:
        return Text(
          Order.statusToString(status),
          style: textTheme!.merge(const TextStyle(color: Colors.amber)),
        );
      case OrderStatus.DELIVERING:
        return Text(
          Order.statusToString(status),
          style: textTheme!.merge(const TextStyle(color: Colors.amber)),
        );
      case OrderStatus.DELIVERED:
        return Text(
          Order.statusToString(status),
          style: textTheme!.merge(const TextStyle(color: Colors.green)),
        );
      default:
        return Text(
          Order.statusToString(status),
          style: textTheme!.merge(const TextStyle(color: Colors.grey)),
        );
    }
  }
}
