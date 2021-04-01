import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/entities/product_entity.dart';

class Product extends Equatable {
  const Product({
    this.id,
    required this.name,
    required this.available,
    required this.maxAmount,
  });

  final String? id;
  final String name;
  final bool available;
  final int maxAmount;

  static const empty = Product(id: "", name: "", available: false, maxAmount: 0);

  @override
  List<Object?> get props => [id, name, available, maxAmount];

  Product copyWith({
    String? id,
    String? name,
    bool? available,
    ImageProvider? image,
    int? maxAmount,
  }) {
    return Product(
      name: name ?? this.name,
      available: available ?? this.available,
      id: id ?? this.id,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(id, name, available, maxAmount);
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      available: entity.available,
      maxAmount: entity.maxAmount,
    );
  }
}
