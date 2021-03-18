import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  ArticleEntity(
    this.id,
    this.productId,
    this.categoryId,
    this.amount,
  );

  final String? id;
  final String productId;
  final String categoryId;
  final int amount;

  @override
  List<Object?> get props => [
        this.id,
        this.productId,
        this.categoryId,
        this.amount,
      ];

  @override
  String toString() =>
      "ArticleEntity { id: $id, categoryId: $categoryId, productId: $productId, amount: $amount }";

  static ArticleEntity fromJson(Map<String, Object> json) => ArticleEntity(
        json["id"] as String,
        json["product_id"] as String,
        json["category_id"] as String,
        json["amount"] as int,
      );

  static ArticleEntity fromSnapshot(DocumentSnapshot snapshot) => ArticleEntity(
        snapshot.id,
        snapshot.get("product_id") as String,
        snapshot.get("category_id") as String,
        snapshot.get("amount") as int,
      );

  Map<String, Object> toDocument() => {
        "product_id": productId,
        "category_id": categoryId,
        "amount": amount,
      };
}
