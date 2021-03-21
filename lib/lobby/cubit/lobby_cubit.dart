import 'package:bloc/bloc.dart';
import 'package:news_repository/news_repository.dart';
import 'package:news_repository/model/new.dart';
import 'package:news_repository/rss_news_repository.dart';

import 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit({
    this.newsRepository =
        const RssNewsRepository(targetUrl: "https://xanthos.fr/feed/"),
  }) : super(LobbyState()) {
    updateNews();
  }

  final NewsRepository newsRepository;

  void updateNews() {
    emit(state.copyWith(isLoading: true));
    newsRepository.getNews().listen((List<New> news) {
      print(news);
      emit(state.copyWith(news: news, isLoading: false));
    });
  }
}
