import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/order_entity.dart';
import 'article.dart';
import 'order_status.dart';
export "order_status.dart";

class Order extends Equatable {
  const Order({
    @required this.id,
    @required this.status,
    @required this.createdAt,
    @required this.articles,
    this.deliveredAt,
  })  : assert(id != null),
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
    articles: [],
  );

  @override
  List<Object> get props => [id, status, createdAt, deliveredAt, articles];

  OrderEntity toEntity() {
    return OrderEntity(id, status, createdAt, deliveredAt);
  }

  static Order fromEntity(OrderEntity entity, List<Article> articles) {
    return Order(
      id: entity.id,
      status: entity.status,
      createdAt: entity.createdAt,
      deliveredAt: entity.deliveredAt,
      articles: articles,
    );
  }
}
