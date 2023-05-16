import 'dart:math' as math;

import 'package:allocrepes/allo/order_admin/cubit/order_admin_cubit.dart';
import 'package:allocrepes/allo/order_admin/cubit/order_admin_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';

class OrderAdminView extends StatelessWidget {
  const OrderAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var slivers = [];

    for (var status in OrderStatus.values) {
      slivers.add(SliverPersistentHeader(
        floating: true,
        delegate: _SliverAppBarDelegate(
          minHeight: 40.0,
          maxHeight: 40.0,
          child: Container(
            color: theme.primaryColorDark,
            child: Center(
              child: Text(
                Order.statusToString(status),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ));

      slivers.add(
        _StatusList(
          status: status,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(BlocProvider.of<OrderAdminCubit>(context).fast
            ? 'Commandes RAPIDE'
            : 'Commandes'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) => !const IterableEquality().equals(
              prev.selectedPlaces.keys,
              next.selectedPlaces.keys,
            ),
            builder: (context, state) => const _FilterView(),
          ),
          ...slivers,
        ],
      ),
    );
  }
}

class _StatusList extends StatelessWidget {
  final OrderStatus status;

  const _StatusList({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderAdminCubit, OrderAdminState>(
      buildWhen: (prev, next) => !const IterableEquality().equals(
        prev.getOrders()[status],
        next.getOrders()[status],
      ),
      builder: (context, state) {
        final orders = state.getOrders()[status] ?? [];
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _OrderTile(orders[index]);
            },
            childCount: orders.length,
            findChildIndexCallback: (key) {
              return orders.indexWhere((order) => order.id == (key as ValueKey<String>).value);
            },
          ),
        );
      },
    );
  }
}

class _OrderTile extends StatelessWidget {
  _OrderTile(this.order) : super(key: Key(order.id ?? ''));

  final Order order;

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      key: order.id != null ? Key(order.id ?? '') : null,
      backgroundColor: PlaceUtils.placeToColor(order.place),
      collapsedBackgroundColor: PlaceUtils.placeToColor(order.place),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: order.articles
            .map(
              (article) => BlocBuilder<OrderAdminCubit, OrderAdminState>(
                buildWhen: (prev, next) =>
                    prev.products[article.productId] !=
                    next.products[article.productId],
                builder: (context, state) => Text(
                    '${article.amount.toString()}x ${state.products[article.productId]?.name ?? article.productId}'),
              ),
            )
            .toList(),
      ),
      title: Text(
        "${order.owner} - ${order.createdAt.toLocal().toString().split(".")[0].substring(0, 16)}",
      ),
      children: [
        Text(
          'Nom :',
          style: theme.textTheme.bodySmall,
        ),
        _UserLabel(
          userId: order.owner,
          classe: true,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Adresse :',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          '${PlaceUtils.placeToString(order.place)}  -  ${order.room}',
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Telephone :',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          order.phone,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Commande :',
          style: theme.textTheme.bodySmall,
        ),
        ...order.articles.map(
          (article) => BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) =>
                prev.products[article.productId] !=
                next.products[article.productId],
            builder: (context, state) => Text(
              '${article.amount.toString()}x ${state.products[article.productId]?.name ?? ""}',
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Commentaire :',
              style: theme.textTheme.bodySmall,
            ),
            Text(order.message),
          ],
        ),
        _StateSelector(
          order: order,
        ),
      ],
    );
  }
}

class _FilterView extends StatelessWidget {
  const _FilterView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: ExpansionTile(
        title: const Text('Filtres'),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batiment :',
            style: theme.textTheme.bodySmall,
          ),
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) => !const IterableEquality().equals(
              prev.selectedPlaces.values,
              next.selectedPlaces.values,
            ),
            builder: (context, state) {
              return ExpansionTile(
                title: const Text(
                  'Batiment',
                  overflow: TextOverflow.clip,
                ),
                children: Place.values
                    .map((place) => CheckboxListTile(
                          title: Text(PlaceUtils.placeToString(place)),
                          value: state.selectedPlaces[place] ?? false,
                          tileColor: PlaceUtils.placeToColor(place),
                          onChanged: (bool? activate) =>
                              BlocProvider.of<OrderAdminCubit>(context)
                                  .updateFilterRoom(place, activate ?? false),
                        ))
                    .toList(),
              );
            },
          ),
          Text(
            'Etat :',
            style: theme.textTheme.bodySmall,
          ),
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) => !const IterableEquality().equals(
              prev.selectedStatus.values,
              next.selectedStatus.values,
            ),
            builder: (context, state) {
              return ExpansionTile(
                title: const Text('Etat'),
                children: OrderStatus.values
                    .map(
                      (status) => CheckboxListTile(
                        title: Text(
                          Order.statusToString(status),
                          overflow: TextOverflow.clip,
                        ),
                        value: state.selectedStatus[status] ?? false,
                        onChanged: (bool? activate) =>
                            BlocProvider.of<OrderAdminCubit>(context)
                                .updateFilterStatus(status, activate ?? false),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StateSelector extends StatelessWidget {
  final Order order;

  const _StateSelector({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(Order.statusToString(order.status)),
      children: OrderStatus.values
          .map<ListTile>(
            (status) => ListTile(
              title: Text(Order.statusToString(status)),
              leading: Radio(
                value: status,
                groupValue: order.status,
                onChanged: (value) =>
                    BlocProvider.of<OrderAdminCubit>(context).updateOrderStatus(
                  order,
                  status,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _UserLabel extends Text {
  final String userId;
  final bool surname;
  final bool name;
  final bool classe;
  final bool id;

  const _UserLabel({
    this.classe = false,
    required this.userId,
    this.surname = true,
    this.name = true,
    this.id = false,
  }) : super(userId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: BlocProvider.of<OrderAdminCubit>(context).getUser(userId),
      builder: (context, snap) {
        if (snap.hasData) {
          var res = '';
          if (id) res += '${snap.data?.id ?? ''} ';
          if (surname) res += '${snap.data?.surname ?? ''} ';
          if (name) res += '${snap.data?.name ?? ''} ';
          if (classe) res += '${snap.data?.classe ?? ''} ';

          return Text(res);
        } else {
          return Text(userId);
        }
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
