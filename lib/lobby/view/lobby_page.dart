import 'package:allocrepes/admin_main/view/admin_main_page.dart';
import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:allocrepes/widget/news_card.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyPage());
  }

  const LobbyPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("XANTHOS"),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "XANTHOS",
                        style: textTheme.headline2!
                            .merge(TextStyle(fontFamily: "Oswald")),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(0, 30),
                    ),
                    Text(
                      "Bonjour " +
                          context.watch<AuthenticationBloc>().state.user.name,
                    ),
                  ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                const MenuCard(
                  title: "News",
                ),
                const MenuCard(
                  title: "Concours",
                ),
                const MenuCard(
                  title: "En savoir +",
                ),
                MenuCard(
                  title: "Allo !",
                  onTap: () {
                    Navigator.push(context, OrderListPage.route());
                  },
                ),
                MenuCard(
                  title: "Admin",
                  onTap: () {
                    Navigator.push(context, AdminMainPage.route());
                  },
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  NewsCard(
                    title:
                        "Concours : Arriverez vous à trouver la tête de Miguel dans ces montagnes ?",
                    image:
                        "https://wp-fr.oberlo.com/wp-content/uploads/sites/4/2019/09/banque-images.jpg",
                  ),
                  NewsCard(
                    title: "Décrouvrez Notre Programme",
                    image:
                        "https://d1fmx1rbmqrxrr.cloudfront.net/cnet/i/edit/2019/04/eso1644bsmall.jpg",
                  ),
                  NewsCard(
                    title: "5 Raisons De Ne Pas Voter Pour Les Autres",
                    image:
                        "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
                  ),
                  FlatButton(
                      onPressed: () =>
                          context.read<AuthenticationRepository>().logOut(),
                      child: Text("Logout")),
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
      ),
    );
  }
}
