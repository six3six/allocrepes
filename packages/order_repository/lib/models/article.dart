import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/article_entity.dart';

import 'item.dart';

class Article extends Equatable {
  const Article({
    @required this.id,
    @required this.item,
    @required this.amount,
  })  : assert(id != null),
        assert(amount != null),
        assert(item != null);

  final String id;
  final Item item;
  final int amount;

  static const empty = Article(id: "", item: Item.empty, amount: 0);

  @override
  List<Object> get props => [id, item, amount];

  ArticleEntity toEntity() {
    return ArticleEntity(id, item.id, amount);
  }

  static Article fromEntity(ArticleEntity entity, Item item) {
    return Article(
      id: entity.id,
      item: item,
      amount: entity.amount
    );
  }
}
