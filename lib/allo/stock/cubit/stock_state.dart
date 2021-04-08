import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';

class StockState extends Equatable {
  final Map<Category, List<Product>> categories;
  final Map<String, int> count;

  const StockState({this.categories = const {}, this.count = const {}});

  @override
  List<Object> get props => [categories.values, categories.entries.toList()];

  StockState copyWith({
    Map<Category, List<Product>>? categories,
    Map<String, int>? count,
  }) {
    return StockState(
      categories: categories ?? this.categories,
      count: count ?? this.count,
    );
  }
}
