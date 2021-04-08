import 'package:order_repository/models/order.dart';

import 'stock_state.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit(this.orderRepository) : super(const StockState()) {
    getProducts();
  }

  final OrderRepository orderRepository;

  void getProducts() {
    orderRepository.categories().forEach((cats) {
      Map<Category, List<Product>> categories = {};

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
      Map<String, int> count = {};

      orders.forEach((order) {
        order.articles.forEach((article) {
          count[article.productId] = (count[article.productId] ?? 0) + 1 ;
        });
      });

      emit(state.copyWith(count: count));
    });
  }

  void updateProductMaxAmount(
      Category category, Product product, int maxAmount) {
    orderRepository.updateProductInitialStock(category, product, maxAmount);
  }

  void removeOrders(){
    orderRepository.removeOrders();
  }
}
