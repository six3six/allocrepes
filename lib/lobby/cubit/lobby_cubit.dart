import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:news_repository/model/new.dart';
import 'package:news_repository/news_repository.dart';
import 'package:news_repository/rss_news_repository.dart';
import 'package:setting_repository/setting_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  final NewsRepository _newsRepository;
  final SettingRepository _settingRepository;

  LobbyCubit({
    required SettingRepository settingRepository,
    NewsRepository newsRepository =
        const RssNewsRepository(targetUrl: 'https://xanthos.fr/feed/'),
  })  : _newsRepository = newsRepository,
        _settingRepository = settingRepository,
        super(LobbyState()) {
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

  void updateNews() {
    emit(state.copyWith(isLoading: true));
    _newsRepository.getNews().forEach((List<New> news) {
      print(news);
      emit(state.copyWith(news: news, isLoading: false));
    });
  }

  void knowMore() {
    try {
      launchUrl(
        Uri.parse('https://www.esiee.fr'),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      return;
    }
  }
}
