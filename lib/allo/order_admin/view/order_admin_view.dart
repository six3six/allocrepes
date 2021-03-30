import 'package:allocrepes/allo/order_admin/cubit/order_admin_cubit.dart';
import 'package:allocrepes/allo/order_admin/cubit/order_admin_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderAdminView extends StatelessWidget {
  OrderAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Commandes"),
      ),
      body: BlocBuilder<OrderAdminCubit, OrderAdminState>(
        buildWhen: (prev, next) =>
            prev.orders.keys.toList() != next.orders.keys.toList(),
        builder: (context, state) {
          List<Widget> slivers = [];

          slivers.add(
            BlocBuilder<OrderAdminCubit, OrderAdminState>(
              buildWhen: (prev, next) =>
                  prev.selectedPlaces.keys.toList() !=
                  next.selectedPlaces.keys.toList(),
              builder: (context, state) => _FilterView(
                selectedPlaces: state.selectedPlaces,
                selectedStatus: state.selectedStatus,
              ),
            ),
          );

          state.orders.keys.forEach((status) {
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
              SliverToBoxAdapter(
                child: BlocBuilder<OrderAdminCubit, OrderAdminState>(
                  buildWhen: (prev, next) =>
                      prev.orders[status]?.toList() !=
                          next.orders[status]?.toList() ||
                      prev.expandedOrders != next.expandedOrders,
                  builder: (context, state) {
                    return ExpansionPanelList(
                      expansionCallback: (panelIndex, isExpanded) =>
                          BlocProvider.of<OrderAdminCubit>(context).expandOrder(
                        state.orders[status]?[panelIndex] ?? Order.empty,
                        !isExpanded,
                      ),
                      children: state.orders[status]
                              ?.map((order) => orderToPanel(order,
                                  state.expandedOrders[order.id] ?? false))
                              .toList() ??
                          [],
                    );
                  },
                ),
              ),
            );
          });

          return CustomScrollView(
            slivers: slivers,
          );
        },
      ),
    );
  }

  ExpansionPanel orderToPanel(Order order, bool expanded) {
    return ExpansionPanel(
      isExpanded: expanded,
      headerBuilder: (BuildContext context, bool isExpanded) {
        if (isExpanded)
          return ListTile(
            title: Text("Nom : " + (order.owner)),
            tileColor: PlaceUtils.placeToColor(order.place),
          );
        else
          return ListTile(
            title: Text("Nom : " + (order.owner)),
            tileColor: PlaceUtils.placeToColor(order.place),
            selectedTileColor: PlaceUtils.placeToColor(order.place),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.articles
                  .map((article) => _ArticleToProductLabel(
                        article: article,
                      ))
                  .toList(),
            ),
          );
      },
      body: _OrderCompleteView(
        order: order,
      ),
    );
  }
}

class _FilterView extends StatelessWidget {
  final Map<OrderStatus, bool> selectedStatus;
  final Map<Place, bool> selectedPlaces;

  const _FilterView({
    Key? key,
    required this.selectedStatus,
    required this.selectedPlaces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SliverToBoxAdapter(
      child: ExpansionTile(
        title: Text("Filtres"),
        childrenPadding: EdgeInsets.symmetric(horizontal: 10),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Batiment :",
            style: theme.textTheme.caption,
          ),
          BlocBuilder<OrderAdminCubit, OrderAdminState>(
            buildWhen: (prev, next) =>
                prev.selectedPlaces != next.selectedPlaces,
            builder: (context, state) {
              return ExpansionTile(
                title: Text(
                  "Batiment",
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
            "Etat :",
            style: theme.textTheme.caption,
          ),
          ExpansionTile(
            title: Text("Etat"),
            children: OrderStatus.values
                .map(
                  (status) => CheckboxListTile(
                    title: Text(
                      Order.statusToString(status),
                      overflow: TextOverflow.clip,
                    ),
                    value: selectedStatus[status] ?? false,
                    onChanged: (bool? activate) =>
                        BlocProvider.of<OrderAdminCubit>(context)
                            .updateFilterStatus(status, activate ?? false),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String labelGen(Map<dynamic, bool> m) {
    /*
    if (m.values.every((element) => true)) {
      return "Tous";
    }
    */

    String ret = "";
    m.forEach((key, value) {
      if (value == false) return;
      ret += key.toString() + " ";
    });

    return ret;
  }
}

class _OrderCompleteView extends StatelessWidget {
  final Order order;

  const _OrderCompleteView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nom :",
            style: theme.textTheme.caption,
          ),
          _UserLabel(
            userId: order.owner,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Adresse :",
            style: theme.textTheme.caption,
          ),
          Text(
            "${PlaceUtils.placeToString(order.place)}  -  ${order.room}",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Commande :",
            style: theme.textTheme.caption,
          ),
        ]
          ..addAll(order.articles
              .map(
                (article) => _ArticleToProductLabel(
                  article: article,
                ),
              )
              .toList())
          ..add(
            _StateSelector(
              order: order,
            ),
          ),
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

class _ArticleToProductLabel extends StatelessWidget {
  final Article article;

  const _ArticleToProductLabel({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
        future: BlocProvider.of<OrderAdminCubit>(context).getProduct(article),
        builder: (context, snap) {
          if (snap.hasData)
            return Text("${article.amount.toString()}x ${snap.data!.name}");
          else
            return Text("${article.amount.toString()}x ${article.productId}");
        });
  }
}

class _UserLabel extends Text {
  final String userId;

  const _UserLabel({
    Key? key,
    required this.userId,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
  }) : super(
          userId,
          key: key,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
        );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: BlocProvider.of<OrderAdminCubit>(context).getUser(userId),
        builder: (context, snap) {
          if (snap.hasData)
            return Text("${snap.data!.name}");
          else
            return Text("$userId");
        });
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
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
