import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/order_entity.dart';
import 'article.dart';
import 'order_status.dart';
export "order_status.dart";

class Order extends Equatable {
  const Order({
    this.id,
    @required this.userId,
    @required this.status,
    @required this.createdAt,
    @required this.articles,
    @required this.place,
    @required this.room,
    this.deliveredAt,
  })  : assert(status != null),
        assert(place != null),
        assert(room != null),
        assert(userId != null),
        assert(articles != null);

  final String id;
  final String userId;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime deliveredAt;
  final List<Article> articles;
  final String place;
  final String room;

  static const empty = Order(
    id: "",
    userId: "",
    status: OrderStatus.UNKNOWN,
    createdAt: null,
    deliveredAt: null,
    articles: [],
    place: "",
    room: "",
  );

  @override
  List<Object> get props =>
      [id, status, createdAt, deliveredAt, articles, place, room, userId];

  OrderEntity toEntity() {
    return OrderEntity(id, status, userId, createdAt, deliveredAt, place, room);
  }

  static Order fromEntity(OrderEntity entity, List<Article> articles) {
    return Order(
      id: entity.id,
      status: entity.status,
      userId: entity.userId,
      createdAt: entity.createdAt,
      deliveredAt: entity.deliveredAt,
      articles: articles,
      place: entity.place,
      room: entity.room,
    );
  }
}
