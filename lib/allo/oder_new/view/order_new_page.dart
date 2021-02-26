import 'package:flutter/material.dart';

import 'order_new_view.dart';

class OrderNewPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OrderNewPage());
  }

  const OrderNewPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return const OrderNewView();
  }
}
