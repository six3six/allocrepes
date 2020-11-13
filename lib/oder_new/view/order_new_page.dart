import 'package:flutter/material.dart';

import '../../oder_new/view/order_new.dart';

class OrderNewPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderNewPage());
  }

  const OrderNewPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OrderNew();
  }
}
