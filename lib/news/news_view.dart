import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:news_repository/model/news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsView extends StatelessWidget {
  final News article;

  const NewsView({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(article.content);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              article.media,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: 100,
            height: 100,
            child: Html(
              onLinkTap: (url, attributes, element) {
                launchUrl(
                  Uri.parse(url ?? ''),
                  mode: LaunchMode.externalApplication,
                );
              },
              data:
                  '<html><body style="width: 100%">${article.content}</body></html>',
              extensions: [
                IframeHtmlExtension(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
