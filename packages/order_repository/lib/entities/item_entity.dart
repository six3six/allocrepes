import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  ItemEntity(
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
      "CrepeEntity { id: $id, category: $name, category: $category, available: $available }";

  static ItemEntity fromJson(Map<String, Object> json) => ItemEntity(
        json["id"] as String,
        json["name"] as String,
        json["category"] as String,
        json["available"] as bool,
      );

  static ItemEntity fromSnapshot(DocumentSnapshot snapshot) => ItemEntity(
        snapshot.id,
        snapshot.get("name") as String,
        snapshot.get("category") as String,
        snapshot.get("available") as bool,
      );

  Map<String, Object> toDocument() => {
        "name": name,
        "category": category,
        "available": available,
      };
}
