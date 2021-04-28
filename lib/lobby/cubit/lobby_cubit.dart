import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:news_repository/model/new.dart';
import 'package:news_repository/news_repository.dart';
import 'package:news_repository/rss_news_repository.dart';
import 'package:order_repository/order_repository.dart';

import 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  final NewsRepository newsRepository;
  final OrderRepository orderRepository;

  LobbyCubit({
    this.newsRepository =
        const RssNewsRepository(targetUrl: 'https://xanthos.fr/feed/'),
    required this.orderRepository,
  }) : super(LobbyState()) {
    Connectivity().onConnectivityChanged.forEach((result) {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          updateNews();
          break;
        case ConnectivityResult.none:
          break;
      }
    });
    updateNews();

    orderRepository.showOrderPages().forEach((enable) {
      emit(state.copyWith(showOrder: enable));
    });
    orderRepository.showProgramPages().forEach((enable) {
      emit(state.copyWith(showProgram: enable));
    });

    orderRepository.showCls().forEach((enable) {
      emit(state.copyWith(showCls: enable));
    });

    orderRepository.headline().forEach((headline) {
      emit(state.copyWith(headline: headline));
    });

    orderRepository.headlineURL().forEach((headlineURL) {
      emit(state.copyWith(headlineURL: headlineURL));
    });
  }

  void updateNews() {
    emit(state.copyWith(isLoading: true));
    newsRepository.getNews().forEach((List<New> news) {
      print(news);
      emit(state.copyWith(news: news, isLoading: false));
    });
  }
}
