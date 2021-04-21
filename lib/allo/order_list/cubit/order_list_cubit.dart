import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

import 'order_list_state.dart';

class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit(this._orderRepository, this._user)
      : super(const OrderListState()) {
    getOrders();
    Connectivity().checkConnectivity().then(checkConnectivity);
    Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  final OrderRepository _orderRepository;
  final User _user;

  void getOrders() {
    _orderRepository.userOrders(orderStatus: [
      OrderStatus.DELIVERED,
      OrderStatus.CANCELED,
    ]).forEach((orders) => emit(state.copyWith(
          previousOrders: orders,
          isLoading: false,
        )));

    _orderRepository.userOrders(orderStatus: [
      OrderStatus.UNKNOWN,
      OrderStatus.VALIDATING,
      OrderStatus.PENDING,
      OrderStatus.DELIVERING,
    ]).forEach((orders) =>
        emit(state.copyWith(currentOrders: orders, isLoading: false)));
  }

  Future<Product> getProduct(Article article) {
    return _orderRepository.getProduct(article.categoryId, article.productId);
  }

  void checkConnectivity(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        emit(state.copyWith(isConnected: true));
        break;
      case ConnectivityResult.none:
        emit(state.copyWith(isConnected: false));
        break;
    }
  }
}
