import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class ProductsState extends Equatable {
  const ProductsState({this.products = const {}});

  final Map<Category, List<Product>> products;

  @override
  List<Object> get props =>
      [products.keys.toList(), products.values.toList().toList()];
}
