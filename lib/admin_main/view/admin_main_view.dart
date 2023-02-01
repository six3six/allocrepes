import 'package:allocrepes/admin_notif/view/admin_notif_page.dart';
import 'package:allocrepes/admin_user/view/admin_user_page.dart';
import 'package:allocrepes/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminMainView extends StatelessWidget {
  const AdminMainView() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admins'),
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
                        launch(
                          'https://docs.google.com/spreadsheets/d/1T0UaQHJ54quMv9mFMFQVHMiHO_SkY1bWGRw0miQsMik/edit#gid=1528048195',
                        );
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
      ),
    );
  }
}
