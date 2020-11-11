import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/article_entity.dart';

import '../entities/order_entity.dart';
import '../entities/order_entity.dart';

class Article extends Equatable {
  const Article({
    @required this.id,
    @required this.item,
    @required this.amount,
  })  : assert(id != null),
        assert(amount != null),
        assert(item != null);

  final String id;
  final String item;
  final int amount;

  static const empty = Article(id: "", item: "", amount: 0);

  @override
  List<Object> get props => [id, item, amount];

  ArticleEntity toEntity() {
    return ArticleEntity(id, item, amount);
  }

  static Article fromEntity(ArticleEntity entity) {
    return Article(
      id: entity.id,
      item: entity.item,
      amount: entity.amount
    );
  }
}
