import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';

class OrderListState extends Equatable {
  final List<Order> previousOrders;
  final List<Order> currentOrders;

  const OrderListState(
      {this.previousOrders = const [], this.currentOrders = const []})
      : assert(previousOrders != null),
        assert(currentOrders != null);

  @override
  List<Object> get props => [previousOrders, currentOrders];

  OrderListState copyWith(
      {List<Order> previousOrders, List<Order> currentOrders}) {
    return OrderListState(
      previousOrders: previousOrders ?? this.previousOrders,
      currentOrders: currentOrders ?? this.currentOrders,
    );
  }
}
