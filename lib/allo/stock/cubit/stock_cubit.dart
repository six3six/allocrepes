import 'package:bloc/bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

import 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit(this.orderRepository) : super(const StockState()) {
    getProducts();
  }

  final OrderRepository orderRepository;

  void getProducts() {
    orderRepository.categories().forEach((cats) {
      var categories = <Category, List<Product>>{};

      cats.forEach((cat) {
        categories[cat] = [];
        orderRepository.productsFromCategory(cat).forEach((prods) {
          categories[cat] = prods;
          emit(state.copyWith(categories: categories));
        });
      });

      emit(state.copyWith(categories: categories));
    });

    orderRepository
        .orders(orderStatus: [OrderStatus.DELIVERED]).forEach((orders) {
      var count = <String, int>{};

      orders.forEach((order) {
        order.articles.forEach((article) {
          count[article.productId] = (count[article.productId] ?? 0) + 1;
        });
      });

      emit(state.copyWith(count: count));
    });
  }

  void updateProductInitialStock(
    Category category,
    String productId,
    int maxAmount,
  ) {
    orderRepository.updateProductInitialStock(category, productId, maxAmount);
  }

  void removeOrders() {
    orderRepository.removeOrders();
  }
}
