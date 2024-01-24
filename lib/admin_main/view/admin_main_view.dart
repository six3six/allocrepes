import 'package:allocrepes/admin_notif/view/admin_notif_page.dart';
import 'package:allocrepes/admin_user/view/admin_user_page.dart';
import 'package:allocrepes/allo/order_admin/view/order_admin_page.dart';
import 'package:allocrepes/allo/product_list/view/product_list_page.dart';
import 'package:allocrepes/allo/stock/view/stock_page.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminMainView extends StatelessWidget {
  const AdminMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                MenuCard(
                  title: 'Afficher les commandes',
                  onTap: () {
                    Navigator.push(context, OrderAdminPage.route());
                  },
                  icon: Icons.book_outlined,
                ),
                MenuCard(
                  title: 'Afficher les commandes de moins de 1H (PLUS RAPIDE)',
                  onTap: () {
                    Navigator.push(
                      context,
                      OrderAdminPage.route(
                        fast: true,
                      ),
                    );
                  },
                  icon: Icons.book_outlined,
                ),
                MenuCard(
                  title: 'Modifier les produits',
                  onTap: () {
                    Navigator.push(context, ProductListPage.route());
                  },
                  icon: Icons.free_breakfast_outlined,
                ),
                MenuCard(
                  title: 'Modifier les stocks',
                  onTap: () {
                    Navigator.push(context, StockPage.route());
                  },
                  icon: Icons.workspaces_filled,
                ),
                MenuCard(
                  title: 'Afficher les utilisateurs',
                  onTap: () {
                    Navigator.push(context, AdminUserPage.route());
                  },
                  icon: Icons.supervised_user_circle_outlined,
                ),
                MenuCard(
                  title: 'Envoyer une notification',
                  onTap: () {
                    Navigator.push(context, AdminNotifPage.route());
                  },
                  icon: Icons.accessibility,
                ),
                MenuCard(
                  title: 'Accès EDT',
                  onTap: () {
                    try {
                      launchUrl(
                          Uri.parse(
                              'https://docs.google.com/spreadsheets/d/1T0UaQHJ54quMv9mFMFQVHMiHO_SkY1bWGRw0miQsMik/edit#gid=1528048195'),
                          mode: LaunchMode.externalApplication);
                    } catch (e) {
                      return;
                    }
                  },
                  icon: Icons.calendar_today,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
