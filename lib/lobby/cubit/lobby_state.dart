import 'package:equatable/equatable.dart';
import 'package:news_repository/model/news.dart';

class LobbyState extends Equatable {
  final List<News> news;
  final bool isLoading;
  final bool showOrder;
  final bool showProgram;
  final bool showCls;
  final String headline;
  final String headlineURL;
  final List<String> leaderboard;

  const LobbyState({
    this.news = const [],
    this.leaderboard = const [],
    this.isLoading = false,
    this.showOrder = false,
    this.showProgram = false,
    this.showCls = false,
    this.headline = '',
    this.headlineURL = '',
  });

  LobbyState copyWith({
    List<News>? news,
    List<String>? leaderboard,
    bool? isLoading,
    bool? showOrder,
    bool? showProgram,
    bool? showCls,
    String? headline,
    String? headlineURL,
  }) {
    return LobbyState(
      news: news ?? this.news,
      leaderboard: leaderboard ?? this.leaderboard,
      isLoading: isLoading ?? this.isLoading,
      showOrder: showOrder ?? this.showOrder,
      showCls: showCls ?? this.showCls,
      showProgram: showProgram ?? this.showProgram,
      headline: headline ?? this.headline,
      headlineURL: headlineURL ?? this.headlineURL,
    );
  }

  @override
  List<Object> get props => [
        ...news,
        ...leaderboard,
        isLoading,
        showOrder,
        showProgram,
        headline,
        headlineURL,
        showCls,
      ];
}
