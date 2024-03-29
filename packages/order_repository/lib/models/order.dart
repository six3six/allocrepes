import 'package:equatable/equatable.dart';
import 'package:order_repository/models/place.dart';

import '../entities/order_entity.dart';
import 'article.dart';
import 'order_status.dart';
export 'order_status.dart';

class Order extends Equatable {
  const Order({
    this.id,
    required this.owner,
    this.status = OrderStatus.VALIDATING,
    required this.createdAt,
    required this.articles,
    required this.place,
    required this.room,
    this.deliveredAt,
    required this.message,
    required this.phone,
  });

  final String? id;
  final String owner;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final List<Article> articles;
  final Place place;
  final String room;
  final String message;
  final String phone;

  static final empty = Order(
    id: '',
    owner: '',
    status: OrderStatus.UNKNOWN,
    createdAt: DateTime.now(),
    deliveredAt: null,
    articles: [],
    place: Place.UNKNOWN,
    room: '',
    message: '',
    phone: '',
  );

  @override
  List<Object?> get props => [
        id,
        status,
        createdAt,
        deliveredAt,
        articles,
        place,
        room,
        owner,
        message,
        phone,
      ];

  Order copyWith({
    final String? id,
    String? owner,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? deliveredAt,
    List<Article>? articles,
    Place? place,
    String? room,
    String? message,
    String? phone,
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
      message: message ?? this.message,
      phone: phone ?? this.phone,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id,
      status,
      owner,
      createdAt,
      deliveredAt,
      place,
      room,
      message,
      phone,
    );
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
      message: entity.message,
      phone: entity.phone,
    );
  }

  static String statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.CANCELED:
        return 'Annulé';
      case OrderStatus.VALIDATING:
        return 'En cours de validation';
      case OrderStatus.PENDING:
        return 'En cours de préparation';
      case OrderStatus.DELIVERING:
        return 'En cours de livraison';
      case OrderStatus.DELIVERED:
        return 'Livrée';
      default:
        return 'Etat inconnu';
    }
  }
}
