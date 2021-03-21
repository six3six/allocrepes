import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

import 'model/new.dart';
import 'news_repository.dart';

class RssNewsRepository extends NewsRepository {
  final String targetUrl;

  const RssNewsRepository({required this.targetUrl}) : super();

  Future<RssFeed> _getFeed() =>
      http.read(Uri.parse(targetUrl)).then((xmlString) {
        return RssFeed.parse(xmlString);
      });

  @override
  Stream<List<New>> getNews() async* {
    RssFeed feed = await _getFeed();
    yield feed.items.map<New>((RssItem item) => New.fromRss(item)).toList();
  }
}
