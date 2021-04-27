import 'package:equatable/equatable.dart';
import 'package:news_repository/model/new.dart';

class LobbyState extends Equatable {
  final List<New> news;
  final bool isLoading;
  final bool showOrder;
  final bool showProgram;

  LobbyState({
    this.news = const <New>[],
    this.isLoading = false,
    this.showOrder = false,
    this.showProgram = false,
  });

  LobbyState copyWith({
    List<New>? news,
    bool? isLoading,
    bool? showOrder,
    bool? showProgram,
  }) {
    return LobbyState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      showOrder: showOrder ?? this.showOrder,
      showProgram: showProgram ?? this.showProgram,
    );
  }

  @override
  List<Object> get props => [
        news,
        isLoading,
        showOrder,
        showProgram,
        ...news,
      ];
}
