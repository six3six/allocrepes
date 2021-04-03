import 'package:allocrepes/admin_notif/view/admin_notif_page.dart';
import 'package:allocrepes/admin_user/view/admin_user_page.dart';
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
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  MenuCard(
                    title: "Afficher les commandes",
                    onTap: () {
                      Navigator.push(context, OrderAdminPage.route());
                    },
                    icon: Icons.book_outlined,
                  ),
                  MenuCard(
                    title: "Modifier les produits",
                    onTap: () {
                      Navigator.push(context, ProductListPage.route());
                    },
                    icon: Icons.free_breakfast_outlined,
                  ),
                  MenuCard(
                    title: "Afficher les utilisateurs",
                    onTap: () {
                      Navigator.push(context, AdminUserPage.route());
                    },
                    icon: Icons.supervised_user_circle_outlined,
                  ),
                  MenuCard(
                    title: "Envoyer une notification",
                    onTap: () {
                      Navigator.push(context, AdminNotifPage.route());
                    },
                    icon: Icons.accessibility,
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
