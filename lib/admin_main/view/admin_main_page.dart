import 'package:flutter/material.dart';

import 'admin_main_view.dart';

class AdminMainPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => AdminMainPage(),
      settings: RouteSettings(name: 'AdminMain'),
    );
  }

  AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
      ),
      body: const AdminMainView(),
    );
  }
}
