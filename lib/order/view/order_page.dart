import 'package:flutter/material.dart';

import 'order_new.dart';

class OrderPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderPage());
  }

  const OrderPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OrderNew();
  }
}
