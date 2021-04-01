import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  ProductEntity(
    this.id,
    this.name,
    this.available,
    this.maxAmount,
  );

  final String? id;
  final String name;
  final bool available;
  final int maxAmount;

  @override
  List<Object?> get props => [
        this.id,
        this.name,
        this.available,
        this.maxAmount,
      ];

  @override
  String toString() =>
      "ProductEntity { id: $id, category: $name, available: $available, maxAmount: $maxAmount }";

  static ProductEntity fromJson(Map<String, Object> json) => ProductEntity(
        json["id"] as String,
        json["name"] as String,
        json["available"] as bool,
        json["maxAmount"] as int,
      );

  static ProductEntity fromSnapshot(DocumentSnapshot snapshot) => ProductEntity(
        snapshot.id,
        snapshot.get("name") as String,
        snapshot.get("available") as bool,
        snapshot.data()?["maxAmount"] ?? 0,
      );

  Map<String, Object> toDocument() => {
        "name": name,
        "available": available,
        "maxAmount": maxAmount,
      };
}
