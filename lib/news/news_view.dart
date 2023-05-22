import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:news_repository/model/news.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatelessWidget {
  final News article;

  const NewsView({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = article.content
        .replaceFirst(RegExp(r'^<img.*?>'), '')
        .replaceAll(RegExp(r'width=".*?"'), '');
    if (kDebugMode) {
      print(data);
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: article.media == '' ? null : 200.0,
          flexibleSpace: article.media == ''
              ? null
              : FlexibleSpaceBar(
                  background: Image.network(
                    article.media,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
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
          child: SizedBox(
            width: double.infinity,
            child: Html(
              onLinkTap: (url, attributes, element) {
                launchUrl(
                  Uri.parse(url ?? ''),
                  mode: LaunchMode.externalApplication,
                );
              },
              data: data,
              extensions: const [
                IframeHtmlExtension(),
              ],
              style: {
                '.kg-card': Style(
                  width: Width(100, Unit.percent),
                ),
                'iframe': Style(
                  width: Width(300, Unit.px),
                  height: Height(300, Unit.px),
                ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
