import 'package:http/http.dart' as http;

import 'model/news.dart';
import 'news_repository.dart';
import 'package:xml/xml.dart';

class RssNewsRepository extends NewsRepository {
  final String targetUrl;

  const RssNewsRepository({required this.targetUrl}) : super();

  Future<XmlDocument> _getFeed() =>
      http.read(Uri.parse(targetUrl)).then((xmlString) {
        return XmlDocument.parse(xmlString.replaceAll('https://xanthos.fr', 'https://lfpn.fr'));
      });

  @override
  Future<List<News>> getNews() async {
    XmlDocument feed = await _getFeed();

    return feed.findAllElements('item').map((item) => News.fromRss(item)).toList();
  }
}
