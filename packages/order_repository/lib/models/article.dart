import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/article_entity.dart';

import 'product.dart';

class Article extends Equatable {
  const Article({
    this.id,
    @required this.productId,
    @required this.categoryId,
    @required this.amount,
  })  : assert(amount != null),
        assert(categoryId != null),
        assert(productId != null);

  final String id;
  final String productId;
  final String categoryId;
  final int amount;

  static const empty =
      Article(id: "", productId: "", categoryId: "", amount: 0);

  @override
  List<Object> get props => [id, productId, categoryId, amount];

  ArticleEntity toEntity() {
    return ArticleEntity(id, productId, categoryId, amount);
  }

  static Article fromEntity(ArticleEntity entity) {
    return Article(
      id: entity.id,
      productId: entity.productId,
      categoryId: entity.categoryId,
      amount: entity.amount,
    );
  }
}
