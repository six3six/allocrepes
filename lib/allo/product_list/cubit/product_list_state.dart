import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class ProductListState extends Equatable {
  final Map<Category, List<Product>> categories;
  final bool showOrderPages;

  const ProductListState({
    this.categories = const {},
    this.showOrderPages = false,
  });

  @override
  List<Object> get props => [
        categories.values.toList(),
        categories.entries.toList(),
        showOrderPages,
      ];

  ProductListState copyWith({
    Map<Category, List<Product>>? categories,
    bool? showOrderPages,
  }) {
    return ProductListState(
      categories: categories ?? this.categories,
      showOrderPages: showOrderPages ?? this.showOrderPages,
    );
  }
}
