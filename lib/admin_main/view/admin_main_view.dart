import 'package:allocrepes/allo/order_admin/view/order_admin_page.dart';
import 'package:allocrepes/allo/product_list/view/product_list_page.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminMainView extends StatelessWidget {
  const AdminMainView() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admins"),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                MenuCard(
                  title: "Afficher les commandes",
                  onTap: () {
                    Navigator.push(context, OrderAdminPage.route());
                  },
                ),
                MenuCard(
                  title: "Modifier les produits",
                  onTap: () {
                    Navigator.push(context, ProductListPage.route());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
