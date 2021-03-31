import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final String image;
  final String title;
  final GestureTapCallback? onTap;

  const NewsCard({
    Key? key,
    required this.image,
    required this.title,
    this.onTap,
  }) : super(key: key);

  static NewsCard tapUrl({
    Key? key,
    required String image,
    required String title,
    required String url,
  }) {
    return NewsCard(
        image: image,
        title: title,
        onTap: () async {
          await canLaunch(url)
              ? await launch(url)
              : throw 'Could not launch $url';
        });
  }

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ));

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 600.0,
      ),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: image.length != 0
                    ? Image.network(
                        image,
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                      )
                    : Image.asset("assets/logo.png"),
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
      ),
    );
  }
}
