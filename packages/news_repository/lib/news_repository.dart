import 'model/new.dart';

abstract class NewsRepository {
  const NewsRepository();
  Stream<List<New>> getNews();
}
