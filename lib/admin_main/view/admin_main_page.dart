import 'package:flutter/material.dart';

import 'admin_main_view.dart';

class AdminMainPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AdminMainPage(),
      settings: const RouteSettings(name: 'AdminMain'),
    );
  }

  const AdminMainPage({Key? key}) : super(key: key);

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
