import 'package:equatable/equatable.dart';
import 'package:news_repository/model/new.dart';

class LobbyState extends Equatable {
  final List<New> news;
  final bool isLoading;
  final bool showOrder;
  final bool showProgram;
  final bool showCls;
  final String headline;
  final String headlineURL;

  LobbyState({
    this.news = const <New>[],
    this.isLoading = false,
    this.showOrder = false,
    this.showProgram = false,
    this.showCls = false,
    this.headline = '',
    this.headlineURL = '',
  });

  LobbyState copyWith({
    List<New>? news,
    bool? isLoading,
    bool? showOrder,
    bool? showProgram,
    bool? showCls,
    String? headline,
    String? headlineURL,
  }) {
    return LobbyState(
      news: news ?? this.news,
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
        news,
        isLoading,
        showOrder,
        showProgram,
        headline,
        headlineURL,
        showCls,
        ...news,
      ];
}
