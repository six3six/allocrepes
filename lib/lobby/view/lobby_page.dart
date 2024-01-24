import 'package:allocrepes/admin_main/view/admin_main_page.dart';
import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/view/lobby_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setting_repository/setting_repository_firestore.dart';

import '../../theme.dart';

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

    final bigWindow = isBigScreen(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => Scaffold(
        bottomNavigationBar:
            bigWindow ? null : buildNavbar(state.user.admin, _barIndex),
        body: bigWindow
            ? Row(
                children: [
                  buildNavrail(state.user.admin, _barIndex),
                  Expanded(child: selectedView),
                ],
              )
            : selectedView,
      ),
    );
  }

  Widget buildNavbar(bool isAdmin, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.other_houses_rounded),
          label: 'Accueil',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Commandes',
        ),
        if (isAdmin)
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Admin',
          ),
      ],
      onTap: (index) => setState(() {
        _barIndex = index;
      }),
    );
  }

  Widget buildNavrail(bool isAdmin, int index) {
    return NavigationRail(
      onDestinationSelected: (index) => setState(() {
        _barIndex = index;
      }),
      selectedIndex: _barIndex,
      groupAlignment: -0.9,
      labelType: NavigationRailLabelType.all,
      leading: Image.asset(
        'assets/logo.png',
        width: 60,
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.other_houses_rounded),
          label: Text('Accueil'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.shopping_cart),
          label: Text('Commandes'),
        ),
        if (isAdmin)
          const NavigationRailDestination(
            icon: Icon(Icons.settings),
            label: Text('Admin'),
          ),
      ],
    );
  }
}
