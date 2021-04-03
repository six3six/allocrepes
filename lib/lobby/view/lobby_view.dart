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
import 'package:url_launcher/url_launcher.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: "logo",
                    child: Image.asset(
                      "assets/logo.png",
                      height: 250,
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(0, 30),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) => Text(
                        "Bonjour " + state.user.surname,
                        style: textTheme.subtitle1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state) =>
                          Text("Points : " + state.user.point.toString()),
                    ),
                    TextButton(
                      onPressed: () =>
                          RepositoryProvider.of<AuthenticationRepository>(
                                  context)
                              .logOut(),
                      child: Text("Se déconnecter"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            children: <Widget>[
              MenuCard(
                title: "Passer commande",
                onTap: () {
                  Navigator.push(context, OrderListPage.route());
                },
                icon: Icons.shopping_cart,
              ),
              MenuCard(
                title: "En savoir +",
                onTap: () {
                  try {
                    launch("https://xanthos.fr/a-propos");
                  } catch (e) {}
                },
                icon: Icons.mood_rounded,
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state.user.admin)
                  return MenuCard(
                    title: "Admin",
                    onTap: () {
                      Navigator.push(context, AdminMainPage.route());
                    },
                    icon: Icons.admin_panel_settings_outlined,
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
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Fait avec le ❤"),
                      Text("par Louis DESPLANCHE"),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Aucun test n'a été dev pour ce projet"),
                      Text(
                        "Tester c'est douter",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("(c) Liste BDE ESIEE Paris 2021-2022"),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
