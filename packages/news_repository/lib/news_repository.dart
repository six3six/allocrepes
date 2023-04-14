import 'model/news.dart';

abstract class NewsRepository {
  const NewsRepository();
  Future<List<News>> getNews();
}
