import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  ProductEntity(
    this.id,
    this.name,
    this.category,
    this.available,
  );

  final String id;
  final String category;
  final String name;
  final bool available;

  @override
  List<Object> get props => [
        this.id,
        this.category,
        this.name,
        this.available,
      ];

  @override
  String toString() =>
      "ProductEntity { id: $id, category: $name, category: $category, available: $available }";

  static ProductEntity fromJson(Map<String, Object> json) =>
      ProductEntity(
        json["id"] as String,
        json["name"] as String,
        json["category"] as String,
        json["available"] as bool,
      );

  static ProductEntity fromSnapshot(DocumentSnapshot snapshot) =>
      ProductEntity(
        snapshot.id,
        snapshot.get("name") as String,
        snapshot.reference.parent.parent.id,
        snapshot.get("available") as bool,
      );

  Map<String, Object> toDocument() => {
        "name": name,
        "available": available,
      };
}
