import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order_status.dart';
import 'package:order_repository/models/place.dart';

class OrderEntity extends Equatable {
  OrderEntity(
    this.id,
    this.status,
    this.owner,
    this.createdAt,
    this.deliveredAt,
    this.place,
    this.room,
  );

  final String? id;
  final String owner;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final Place place;
  final String room;

  @override
  List<Object?> get props => [
        this.id,
        this.status,
        this.createdAt,
        this.deliveredAt,
        this.place,
        this.room,
        this.owner,
      ];

  @override
  String toString() =>
      "OrderEntity { id: $id, status: $status, created_at: $createdAt, delivered_at: $deliveredAt, place: $place, room: $room, owner: $owner }";

  static OrderEntity fromJson(Map<String, Object> json) => OrderEntity(
        json["id"] as String,
        OrderStatus.values[(json["status"] as int)],
        json["owner"] as String,
        DateTime.parse(json["created_at"].toString()),
        DateTime.parse(json["delivered_at"].toString()),
        Place.values[json["place"] as int],
        json["room"] as String,
      );

  static OrderEntity fromSnapshot(DocumentSnapshot snapshot) => OrderEntity(
        snapshot.id,
        OrderStatus.values[(snapshot.get("status") as int)],
        snapshot.get("owner") as String,
        (snapshot.get("created_at") as Timestamp).toDate(),
        (snapshot.get("delivered_at") as Timestamp?)?.toDate(),
        Place.values[snapshot.get("place") as int],
        snapshot.get("room") as String,
      );

  Map<String, Object?> toDocument() => {
        "status": status.index,
        "owner": owner,
        "created_at": createdAt,
        "delivered_at": deliveredAt,
        "place": place,
        "room": room,
      };
}
