import 'package:allocrepes/admin_main/view/admin_main_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/lobby/cubit/lobby_cubit.dart';
import 'package:allocrepes/lobby/cubit/lobby_state.dart';
import 'package:allocrepes/program/view/program_page.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:allocrepes/widget/news_card.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
        _LobbyCls(),
        _LobbyActuMenu(),
      ],
    );
  }
}

class _LobbyCls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final getList = FirebaseFunctions.instance.httpsCallable('getPointsCls');

    return SliverToBoxAdapter(
      child: BlocBuilder<LobbyCubit, LobbyState>(
        builder: (context, state) {
          return state.showCls
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Classement des meilleurs athlètes',
                        style: textTheme.headline5,
                      ),
                      FutureBuilder<HttpsCallableResult<List<dynamic>>>(
                        future: getList(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox();
                          var list = snapshot.data;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: list?.data
                                      .map((e) => Text(
                                            e,
                                            style: textTheme.bodyText1,
                                          ))
                                      .toList() ??
                                  [],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : SizedBox();
        },
      ),
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
                  buildWhen: (prev, next) => prev.headline != next.headline,
                  builder: (context, state) {
                    return state.headline != ''
                        ? SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'News : ' + state.headline,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .merge(TextStyle(color: Colors.red)),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          )
                        : SizedBox();
                  },
                ),
                MenuCard(
                  title: 'En savoir +',
                  onTap: () {
                    try {
                      launch('https://xanthos.fr/a-propos');
                    } catch (e) {
                      return;
                    }
                  },
                  icon: Icons.mood_rounded,
                ),
                BlocBuilder<LobbyCubit, LobbyState>(
                  builder: (context, state) {
                    return MenuCard(
                      title: 'Notre Programme ! ',
                      onTap: () => Navigator.push(context, ProgramPage.route()),
                      icon: Icons.book,
                      enable: state.showProgram,
                    );
                  },
                ),
                if (state.user.admin)
                  MenuCard(
                    title: 'Admin',
                    onTap: () {
                      Navigator.push(context, AdminMainPage.route());
                    },
                    icon: Icons.settings,
                  ),
                if (state.user.id == 'lefevret')
                  Column(
                    children: [
                      Text(
                        'Sexe.',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text('Signé Louis <3'),
                    ],
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
              'Suivre Xanthos sur Twitch',
              style: textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: LobbyTwitchViewer(),
          ),
          SizedBox(height: 10),
          BlocBuilder<LobbyCubit, LobbyState>(
            buildWhen: (prev, next) => prev.headlineURL != next.headlineURL,
            builder: (context, state) =>
                LobbyHeadlineViewer(url: state.headlineURL),
          )
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
              'Suivre les actus Xanthos',
              style: textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<LobbyCubit, LobbyState>(
              builder: (context, state) {
                if (state.news.isEmpty) {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Text("Il n'y a pas de news pour le moment"),
                    ),
                  );
                }

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
