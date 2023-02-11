import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/entities/product_entity.dart';

class Product extends Equatable {
  const Product({
    this.id,
    required this.name,
    required this.available,
    required this.availableESIEE,
    required this.maxAmount,
    required this.initialStock,
    required this.oneOrder,
  });

  final String? id;
  final String name;
  final bool available;
  final bool availableESIEE;
  final int maxAmount;
  final int initialStock;
  final bool oneOrder;

  static const empty = Product(
    id: '',
    name: '',
    available: false,
    availableESIEE: false,
    maxAmount: 0,
    initialStock: 0,
    oneOrder: false,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        available,
        maxAmount,
        initialStock,
        availableESIEE,
        oneOrder,
      ];

  Product copyWith({
    String? id,
    String? name,
    bool? available,
    bool? availableESIEE,
    ImageProvider? image,
    int? maxAmount,
    int? initialStock,
    bool? oneOrder,
  }) {
    return Product(
      name: name ?? this.name,
      available: available ?? this.available,
      availableESIEE: availableESIEE ?? this.availableESIEE,
      id: id ?? this.id,
      maxAmount: maxAmount ?? this.maxAmount,
      initialStock: initialStock ?? this.initialStock,
      oneOrder: oneOrder ?? this.oneOrder,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id,
      name,
      available,
      availableESIEE,
      maxAmount,
      initialStock,
      oneOrder,
    );
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      available: entity.available,
      availableESIEE: entity.availableESIEE,
      maxAmount: entity.maxAmount,
      initialStock: entity.initialStock,
      oneOrder: entity.oneOrder,
    );
  }
}
