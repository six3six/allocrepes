import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/order_repository.dart';

import 'order_list_state.dart';

class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit(this._orderRepository, this._user)
      : super(const OrderListState()) {
    getOrders();
  }

  final OrderRepository _orderRepository;
  final User _user;

  void getOrders() {
    _orderRepository.orders(userId: _user.id, delivered: true).map(
        (List<Order> orders) => emit(state.copyWith(previousOrders: orders)));

    _orderRepository.orders(userId: _user.id, delivered: false).map(
        (List<Order> orders) => emit(state.copyWith(currentOrders: orders)));
  }
}