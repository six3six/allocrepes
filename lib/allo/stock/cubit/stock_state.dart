import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class StockState extends Equatable {
  final Map<Category, List<Product>> categories;
  final Map<String, int> count;

  const StockState({this.categories = const {}, this.count = const {}});

  @override
  List<Object> get props =>
      []..addAll(categories.keys)..addAll(categories.entries);

  StockState copyWith({
    Map<Category, List<Product>>? categories,
    Map<String, int>? count,
  }) {
    return StockState(
      categories: categories ?? this.categories,
      count: count ?? this.count,
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
