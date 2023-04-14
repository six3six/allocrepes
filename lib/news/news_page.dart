import 'package:allocrepes/news/news_view.dart';
import 'package:flutter/material.dart';
import 'package:news_repository/model/news.dart';


class NewsPage extends StatelessWidget {
  final News article;

  const NewsPage({
    Key? key,
    required this.article,
  }) : super(key: key);

  static Route route(News article) {
    return MaterialPageRoute(
      builder: (_) => NewsPage(
        article: article,
      ),
      settings:
      RouteSettings(name: '/article/' + article.title.replaceAll(' ', '_')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NewsView(
        article: article,
      ),
    );
  }
}