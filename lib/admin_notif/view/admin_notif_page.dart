import 'package:allocrepes/admin_notif/cubit/admin_notif_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_notif_view.dart';

class AdminNotifPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => AdminNotifPage(),
      settings: RouteSettings(name: "AdminNotif"),
    );
  }

  AdminNotifPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminNotifCubit>(
      create: (context) => AdminNotifCubit(),
      child: const AdminNotifView(),
    );
  }
}
