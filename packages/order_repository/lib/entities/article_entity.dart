import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  ArticleEntity(
    this.id,
    this.item,
    this.amount,
  );

  final String id;
  final String item;
  final int amount;

  @override
  List<Object> get props => [
        this.id,
        this.item,
        this.amount,
      ];

  @override
  String toString() =>
      "ArticleEntity { id: $id, item: $item, amount: $amount }";

  static ArticleEntity fromJson(Map<String, Object> json) => ArticleEntity(
        json["id"] as String,
        json["item"] as String,
        json["amount"] as int,
      );

  static ArticleEntity fromSnapshot(DocumentSnapshot snapshot) => ArticleEntity(
        snapshot.id,
        snapshot.get("item") as String,
        snapshot.get("amount") as int,
      );

  Map<String, Object> toDocument() => {
        "item": item,
        "amount": amount,
      };
}
