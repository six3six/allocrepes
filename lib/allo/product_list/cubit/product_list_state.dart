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
        showOrderPages,
        ...categories.values,
        ...categories.keys,
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

  Product getProduct(
    Category category,
    int rank,
  ) {
    try {
      return categories[category]?.elementAt(rank) ?? Product.empty;
    } catch (e) {
      return Product.empty;
    }
  }
}
