import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:news_repository/model/news.dart';
import 'package:news_repository/news_repository.dart';
import 'package:news_repository/rss_news_repository.dart';
import 'package:setting_repository/setting_repository.dart';

import 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  final NewsRepository _newsRepository;
  final SettingRepository _settingRepository;

  final _getLeaderboard =
      FirebaseFunctions.instance.httpsCallable('getPointsCls');

  LobbyCubit({
    required SettingRepository settingRepository,
    NewsRepository newsRepository =
        const RssNewsRepository(targetUrl: 'https://selva.lfpn.fr/rss/'),
  })  : _newsRepository = newsRepository,
        _settingRepository = settingRepository,
        super(const LobbyState()) {
    Connectivity().onConnectivityChanged.forEach((result) {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          updateNews();
          updateLeaderboard();
          break;
        case ConnectivityResult.none:
          break;
      }
    });
    updateNews();
    updateLeaderboard();

    _settingRepository.showOrderPages().forEach((enable) {
      emit(state.copyWith(showOrder: enable));
    });
    _settingRepository.showProgramPages().forEach((enable) {
      emit(state.copyWith(showProgram: enable));
    });

    _settingRepository.showCls().forEach((enable) {
      emit(state.copyWith(showCls: enable));
    });

    _settingRepository.headline().forEach((headline) {
      emit(state.copyWith(headline: headline));
    });

    _settingRepository.headlineURL().forEach((headlineURL) {
      emit(state.copyWith(headlineURL: headlineURL));
    });
  }

  void updateLeaderboard() async {
    final leaderboardResult = await _getLeaderboard();

    var res = <String>[];
    for (final row in leaderboardResult.data) {
      res.add(row);
    }
    emit(state.copyWith(leaderboard: res));
  }

  void updateNews() {
    emit(state.copyWith(isLoading: true));
    _newsRepository.getNews().then((List<News> news) {
      print(news);
      emit(state.copyWith(news: news, isLoading: false));
    });
  }
}
