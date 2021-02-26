import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/product_entity.dart';

class Product extends Equatable {
  const Product({
    this.id,
    @required this.name,
    @required this.available,
    this.image = const NetworkImage(
        "https://www.hervecuisine.com/wp-content/uploads/2010/11/recette-crepes.jpg"),
  })  : assert(name != null),
        assert(available != null);

  final String id;
  final String name;
  final bool available;
  final ImageProvider image;

  static const empty = Product(id: "", name: "", available: false);

  @override
  List<Object> get props => [id, name, available, image];

  ProductEntity toEntity() {
    return ProductEntity(id, name, available);
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      available: entity.available,
    );
  }
}
