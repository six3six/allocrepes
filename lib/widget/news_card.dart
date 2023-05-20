import 'package:allocrepes/news/news_page.dart';
import 'package:flutter/material.dart';
import 'package:news_repository/model/news.dart';

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context).textTheme.bodyLarge!.merge(const TextStyle(
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
          onTap: () => Navigator.of(context).push(NewsPage.route(news)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: news.media.isNotEmpty
                    ? Image.network(
                        news.media,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                    : Image.asset('assets/logo.png'),
              ),
              ListTile(
                title: Container(
                  padding: const EdgeInsets.only(right: 20, bottom: 20, top: 10),
                  child: Text(
                    news.title,
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
