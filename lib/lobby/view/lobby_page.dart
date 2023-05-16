import 'package:allocrepes/admin_main/view/admin_main_page.dart';
import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/view/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setting_repository/setting_repository_firestore.dart';

class LobbyPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => LobbyCubit(
          settingRepository:
              RepositoryProvider.of<SettingRepositoryFirestore>(context),
        ),
        child: const LobbyPage(),
      ),
      settings: const RouteSettings(name: 'Main'),
    );
  }

  const LobbyPage({Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  int _barIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget selectedView;

    switch (_barIndex) {
      case 0:
        selectedView = const LobbyView();
        break;
      case 1:
        selectedView = const OrderListPage();
        break;
      case 2:
        selectedView = const AdminMainPage();
        break;
      default:
        selectedView = const LobbyView();
        break;
    }
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => Scaffold(

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _barIndex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.other_houses_rounded),
              label: 'Accueil',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Commandes',
            ),
            if (state.user.admin)
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Admin',
              ),
          ],
          onTap: (index) => setState(() {
            _barIndex = index;
          }),
        ),
        body: selectedView,
      ),
    );
  }
}
