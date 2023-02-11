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
  OrderAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var slivers = [];

    OrderStatus.values.forEach((status) {
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
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(BlocProvider.of<OrderAdminCubit>(context).fast
            ? 'Commandes RAPIDE'
            : 'Commandes'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) => !IterableEquality().equals(
              prev.selectedPlaces.keys,
              next.selectedPlaces.keys,
            ),
            builder: (context, state) => _FilterView(),
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
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) => !IterableEquality().equals(
              prev.getOrders()[status],
              next.getOrders()[status],
            ),
            builder: (context, state) {
              final orders =
                  BlocProvider.of<OrderAdminCubit>(context).state.getOrders();

              return Column(
                children: orders[status]
                        ?.map((order) => _OrderTile(order))
                        .toList() ??
                    [],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  _OrderTile(this.order);

  final Order order;

  @override
  Widget build(context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      key: order.id != null ? Key(order.id ?? '') : null,
      backgroundColor: PlaceUtils.placeToColor(order.place),
      collapsedBackgroundColor: PlaceUtils.placeToColor(order.place),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
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
        SizedBox(
          height: 10,
        ),
        Text(
          'Adresse :',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          '${PlaceUtils.placeToString(order.place)}  -  ${order.room}',
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Telephone :',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          '${order.phone}',
        ),
        SizedBox(
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
            SizedBox(height: 10),
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
        title: Text('Filtres'),
        childrenPadding: EdgeInsets.symmetric(horizontal: 10),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batiment :',
            style: theme.textTheme.bodySmall,
          ),
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) => !IterableEquality().equals(
              prev.selectedPlaces.values,
              next.selectedPlaces.values,
            ),
            builder: (context, state) {
              return ExpansionTile(
                title: Text(
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
            buildWhen: (prev, next) => !IterableEquality().equals(
              prev.selectedStatus.values,
              next.selectedStatus.values,
            ),
            builder: (context, state) {
              return ExpansionTile(
                title: Text('Etat'),
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
    this.surname = true,
    this.name = true,
    this.classe = false,
    this.id = false,
    required this.userId,
  }) : super(userId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: BlocProvider.of<OrderAdminCubit>(context).getUser(userId),
      builder: (context, snap) {
        if (snap.hasData) {
          var res = '';
          if (id) res += (snap.data?.id ?? '') + ' ';
          if (surname) res += (snap.data?.surname ?? '') + ' ';
          if (name) res += (snap.data?.name ?? '') + ' ';
          if (classe) res += (snap.data?.classe ?? '') + ' ';

          return Text(res);
        } else {
          return Text('$userId');
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
