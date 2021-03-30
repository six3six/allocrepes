import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  ProductEntity(
    this.id,
    this.name,
    this.available,
  );

  final String? id;
  final String name;
  final bool available;

  @override
  List<Object?> get props => [
        this.id,
        this.name,
        this.available,
      ];

  @override
  String toString() =>
      "ProductEntity { id: $id, category: $name, available: $available }";

  static ProductEntity fromJson(Map<String, Object> json) => ProductEntity(
        json["id"] as String,
        json["name"] as String,
        json["available"] as bool,
      );

  static ProductEntity fromSnapshot(DocumentSnapshot snapshot) => ProductEntity(
        snapshot.id,
        snapshot.get("name") as String,
        snapshot.get("available") as bool,
      );

  Map<String, Object> toDocument() => {
        "name": name,
        "available": available,
      };
}
