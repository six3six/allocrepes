import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/article_entity.dart';

import '../entities/order_entity.dart';
import '../entities/order_entity.dart';
import 'article.dart';
import 'order_status.dart';

class Order extends Equatable {
  const Order({
    @required this.id,
    @required this.status,
    @required this.createdAt,
    @required this.deliveredAt,
    @required this.articles,
  })
      : assert(id != null),
        assert(status != null),
        assert(articles != null);

  final String id;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime deliveredAt;
  final List<Article> articles;

  static const empty = Order(
    id: "",
    status: OrderStatus.UNKNOWN,
    createdAt: null,
    deliveredAt: null,
    articles: [],);

  @override
  List<Object> get props => [id, status, createdAt, deliveredAt, articles];

  OrderEntity toEntity() {
    return OrderEntity(id, status, createdAt, deliveredAt);
  }

  static Order fromEntityAndArticles(OrderEntity entity,
      List<Article> articles) {
    return Order(
      id: entity.id,
      status: entity.status,
      createdAt: entity.createdAt,
      deliveredAt: entity.deliveredAt,
      articles: articles,
    );
  }

  static Future<Order> fromEntityAsync(OrderEntity entity) async {
    final QuerySnapshot articlesSnapshot = await FirebaseFirestore.instance
        .collection("orders")
        .doc(entity.id)
        .collection("articles")
        .get();

    final List<Article> articles = articlesSnapshot.docs
        .map((QueryDocumentSnapshot doc) =>
        Article.fromEntity(ArticleEntity.fromSnapshot(doc)))
        .toList();

    return Order(
      id: entity.id,
      status: entity.status,
      createdAt: entity.createdAt,
      deliveredAt: entity.deliveredAt,
      articles: articles,
    );
  }
}
