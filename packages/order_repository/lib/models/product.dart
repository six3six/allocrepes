import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/entities/product_entity.dart';

class Product extends Equatable {
  const Product({
    this.id,
    required this.name,
    required this.available,
    required this.maxAmount,
    required this.initialStock,
  });

  final String? id;
  final String name;
  final bool available;
  final int maxAmount;
  final int initialStock;

  static const empty = Product(
    id: "",
    name: "",
    available: false,
    maxAmount: 0,
    initialStock: 0,
  );

  @override
  List<Object?> get props => [id, name, available, maxAmount, initialStock];

  Product copyWith({
    String? id,
    String? name,
    bool? available,
    ImageProvider? image,
    int? maxAmount,
    int? initialStock,
  }) {
    return Product(
      name: name ?? this.name,
      available: available ?? this.available,
      id: id ?? this.id,
      maxAmount: maxAmount ?? this.maxAmount,
      initialStock: initialStock ?? this.initialStock,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(id, name, available, maxAmount, initialStock);
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      available: entity.available,
      maxAmount: entity.maxAmount,
      initialStock: entity.initialStock,
    );
  }
}
