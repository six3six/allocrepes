import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:allocrepes/allo/product_list/view/product_list_page.dart';
import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyPage());
  }

  const LobbyPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("XANTOS"),
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
                        "XANTOS",
                        style: textTheme.headline2
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
                  title: "Allo admin : modifier les produits",
                  onTap: () {
                    Navigator.push(context, ProductListPage.route());
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const MenuCard({Key key, this.title = "", this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final image;
  final title;

  const NewsCard({Key key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context).textTheme.bodyText1.merge(TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ));
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Image.network(
                image,
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            ListTile(
              title: Container(
                padding: EdgeInsets.only(right: 20, bottom: 20, top: 10),
                child: Text(
                  title,
                  style: headStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
