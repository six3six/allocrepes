import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class ProductListState extends Equatable {
  final Map<Category, List<Product>> categories;

  const ProductListState({this.categories = const {}});

  @override
  List<Object> get props =>
      [categories.values.toList(), categories.entries.toList()];

  ProductListState copyWith({categories}) {
    return ProductListState(
      categories: categories ?? this.categories,
    );
  }
}
