import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/article_entity.dart';

import 'product.dart';

class Article extends Equatable {
  const Article({
    this.id,
    @required this.product,
    @required this.amount,
  })  : assert(amount != null),
        assert(product != null);

  final String id;
  final Product product;
  final int amount;

  static const empty = Article(id: "", product: Product.empty, amount: 0);

  @override
  List<Object> get props => [id, product, amount];

  ArticleEntity toEntity() {
    return ArticleEntity(id, product.id, amount);
  }

  static Article fromEntity(ArticleEntity entity, Product product) {
    return Article(
      id: entity.id,
      product: product,
      amount: entity.amount,
    );
  }
}
