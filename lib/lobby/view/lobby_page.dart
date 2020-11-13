import 'package:allocrepes/authentication/bloc/authentication_bloc.dart';
import 'package:allocrepes/order_list/view/order_list_page.dart';
import 'package:allocrepes/products/view/product_page.dart';
import 'package:authentication_repository/authentication_repository.dart';
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
        title: const Text("Accueil"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(context.watch<AuthenticationBloc>().state.user.id),
          FlatButton(
              onPressed: () =>
                  context.read<AuthenticationRepository>().logOut(),
              child: Text("Logout")),
          FlatButton(
              onPressed: () => Navigator.push(context, OrderListPage.route()),
              child: Text("Commander")),
          FlatButton(
              onPressed: () => Navigator.push(context, ProductPage.route()),
              child: Text("Produits")),
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
        ],
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
