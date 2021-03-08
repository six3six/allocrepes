import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/order_entity.dart';
import 'article.dart';
import 'order_status.dart';
export "order_status.dart";

class Order extends Equatable {
  const Order({
    this.id,
    @required this.owner,
    this.status = OrderStatus.VALIDATING,
    @required this.createdAt,
    @required this.articles,
    @required this.place,
    @required this.room,
    this.deliveredAt,
  })  : assert(status != null),
        assert(place != null),
        assert(room != null),
        assert(owner != null),
        assert(articles != null);

  final String id;
  final String owner;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime deliveredAt;
  final List<Article> articles;
  final String place;
  final String room;

  static const empty = Order(
    id: "",
    owner: "",
    status: OrderStatus.UNKNOWN,
    createdAt: null,
    deliveredAt: null,
    articles: [],
    place: "",
    room: "",
  );

  @override
  List<Object> get props =>
      [id, status, createdAt, deliveredAt, articles, place, room, owner];

  Order copyWith({
    final String id,
    String owner,
    OrderStatus status,
    DateTime createdAt,
    DateTime deliveredAt,
    List<Article> articles,
    String place,
    String room,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      articles: articles ?? this.articles,
      place: place ?? this.place,
      room: room ?? this.room,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(id, status, owner, createdAt, deliveredAt, place, room);
  }

  static Order fromEntity(OrderEntity entity, List<Article> articles) {
    return Order(
      id: entity.id,
      status: entity.status,
      owner: entity.owner,
      createdAt: entity.createdAt,
      deliveredAt: entity.deliveredAt,
      articles: articles,
      place: entity.place,
      room: entity.room,
    );
  }

  static String statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.CANCELED:
        return "Annulé";
        break;
      case OrderStatus.VALIDATING:
        return "En cours de validation";
        break;
      case OrderStatus.PENDING:
        return "En cours de préparation";
        break;
      case OrderStatus.DELIVERING:
        return "En cours de livraison";
        break;
      case OrderStatus.DELIVERED:
        return "Livrée";
        break;
      default:
        return "Etat inconnu";
        break;
    }
  }
}
