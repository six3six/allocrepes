import 'package:allocrepes/admin_main/view/admin_main_page.dart';
import 'package:allocrepes/allo/oder_new/view/order_new_page.dart';
import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/cubit/lobby_state.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:allocrepes/widget/news_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lobby_top.dart';
import 'lobby_twitch.dart';

class LobbyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: LobbyTop(),
          ),
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (prev, next) => prev.user.student != next.user.student,
          builder: (context, state) {
            return state.user.student
                ? _LobbyMenu()
                : SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text("Vous n'êtes pas étudiant..."),
                        Text(
                          "Si c'est une erreur envoyez nous un message sur nos réseaux sociaux...",
                        ),
                      ],
                    ),
                  );
          },
        ),
        if (!kIsWeb) _LobbyTwitchMenu(),
        _LobbyActuMenu(),
      ],
    );
  }
}

class _LobbyMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                BlocBuilder<LobbyCubit, LobbyState>(
                  builder: (context, state) {
                    return MenuCard(
                      title: "Passer commande",
                      onTap: () =>
                          Navigator.push(context, OrderNewPage.route()),
                      icon: Icons.shopping_cart_outlined,
                    );
                  },
                ),
                BlocBuilder<LobbyCubit, LobbyState>(
                  builder: (context, state) {
                    return MenuCard(
                      title: "Mes commandes",
                      onTap: () =>
                          Navigator.push(context, OrderListPage.route()),
                      icon: Icons.shopping_basket_outlined,
                    );
                  },
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
                if (state.user.admin)
                  MenuCard(
                    title: "Admin",
                    onTap: () {
                      Navigator.push(context, AdminMainPage.route());
                    },
                    icon: Icons.settings,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LobbyTwitchMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
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
    );
  }
}

class _LobbyActuMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverPadding(
      padding: const EdgeInsets.all(13),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Suivre les actus Xanthos",
              style: textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<LobbyCubit, LobbyState>(
              builder: (context, state) {
                if (state.news.length == 0)
                  return SizedBox(
                    child: Center(
                      child: Text("Il n'y a pas de news pour le moment"),
                    ),
                    height: 100,
                  );

                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: state.news
                        .map((_new) => NewsCard.tapUrl(
                              title: _new.title,
                              image: _new.media,
                              url: _new.url,
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
