import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order_status.dart';

class OrderEntity extends Equatable {
  OrderEntity(this.id,
      this.status,
      this.createdAt,
      this.deliveredAt,);

  final String id;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime deliveredAt;

  @override
  List<Object> get props =>
      [
        this.id,
        this.status,
        this.createdAt,
        this.deliveredAt,
      ];

  @override
  String toString() =>
      "CrepeEntity { id: $id, status: $status, created_at: $createdAt, delivered_at; $deliveredAt }";

  static OrderEntity fromJson(Map<String, Object> json) =>
      OrderEntity(
        json["id"] as String,
        OrderStatus.values[(json["status"] as int)],
        DateTime.parse(json["created_at"]),
        DateTime.parse(json["delivered_at"]),
      );

  static OrderEntity fromSnapshot(DocumentSnapshot snapshot) =>
      OrderEntity(
        snapshot.id,
        OrderStatus.values[(snapshot.get("status") as int)],
        (snapshot.get("created_at") as Timestamp).toDate(),
        (snapshot.get("delivered_at") as Timestamp).toDate(),
      );

  Map<String, Object> toDocument() =>
      {
        "status": status.index,
        "created_at": createdAt,
        "delivered_at": deliveredAt,
      };
}
