import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  CategoryEntity(
    this.id,
    this.name,
  );

  final String id;
  final String name;

  @override
  List<Object> get props => [
        this.id,
        this.name,
      ];

  @override
  String toString() => "CategoryEntity { id: $id, name: $name }";

  static CategoryEntity fromJson(Map<String, Object> json) => CategoryEntity(
        json["id"] as String,
        json["name"] as String,
      );

  static CategoryEntity fromSnapshot(DocumentSnapshot snapshot) =>
      CategoryEntity(
        snapshot.id,
        snapshot.get("name") as String,
      );

  Map<String, Object> toDocument() => {
        "name": name,
      };
}
