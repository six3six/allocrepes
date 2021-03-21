import 'package:allocrepes/admin_main/view/admin_main_page.dart';
import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/cubit/lobby_state.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:allocrepes/widget/news_card.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lobby_twitch.dart';

class LobbyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "XANTHOS",
                    style: textTheme.headline2
                        ?.merge(TextStyle(fontFamily: "Oswald")),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(0, 30),
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) =>
                      Text("Bonjour " + state.user.name),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              MenuCard(
                title: "Allo !",
                onTap: () {
                  Navigator.push(context, OrderListPage.route());
                },
              ),
              const MenuCard(
                title: "Concours",
              ),
              const MenuCard(
                title: "En savoir +",
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state.user.admin)
                  return MenuCard(
                    title: "Admin",
                    onTap: () {
                      Navigator.push(context, AdminMainPage.route());
                    },
                  );
                else
                  return SizedBox();
              }),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "Suivre Xanthos sur Twitch",
                  style: textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: LobbyTwitchViewer(),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Suivre les actu Xanthos",
                  style: textTheme.headline5,
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<LobbyCubit, LobbyState>(
                  builder: (context, state) {
                    return Column(
                      children: state.news
                          .map((_new) => NewsCard.tapUrl(
                                title: _new.title,
                                image: _new.media,
                                url: _new.url,
                              ))
                          .toList(),
                    );
                  },
                ),
                TextButton(
                  onPressed: () =>
                      RepositoryProvider.of<AuthenticationRepository>(context)
                          .logOut(),
                  child: Text("Se déconnecter"),
                ),
                Text("Aucun test n'a été dev pour ce projet"),
                Text(
                  "Tester c'est douter",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
