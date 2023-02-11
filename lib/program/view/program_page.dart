import 'package:flutter/material.dart';

class ProgramPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => ProgramPage(),
      settings: RouteSettings(name: 'program'),
    );
  }

  ProgramPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notre Programme'),
        actions: [],
      ),
      body: ListView(
        children: [
          Image.asset('assets/programRecto.jpg'),
          Image.asset('assets/programVerso.jpg'),
        ],
      ),
    );
  }
}
