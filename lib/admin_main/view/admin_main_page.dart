import 'package:flutter/material.dart';

import 'admin_main_view.dart';

class AdminMainPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AdminMainPage());
  }

  AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdminMainView();
  }
}
