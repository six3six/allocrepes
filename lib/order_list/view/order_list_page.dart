import 'package:allocrepes/order_list/view/order_list_view.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderListPage());
  }

  const OrderListPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return OrderList();
  }
}
