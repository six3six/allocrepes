import 'package:equatable/equatable.dart';
import 'package:news_repository/model/new.dart';

class LobbyState extends Equatable {
  final List<New> news;
  final bool isLoading;

  LobbyState({
    this.news = const <New>[],
    this.isLoading = false,
  });

  LobbyState copyWith({
    List<New>? news,
    bool? isLoading,
  }) {
    return LobbyState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [news, isLoading];
}
