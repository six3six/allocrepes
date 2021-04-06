import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';

class OrderListState extends Equatable {
  final List<Order> previousOrders;
  final List<Order> currentOrders;



  final bool isLoading;

  const OrderListState({
    this.previousOrders = const [],
    this.currentOrders = const [],
    this.isLoading = true,
  });

  @override
  List<Object> get props => [previousOrders, currentOrders, isLoading];

  OrderListState copyWith({
    List<Order>? previousOrders,
    List<Order>? currentOrders,
    bool? isLoading,
  }) {
    return OrderListState(
      previousOrders: previousOrders ?? this.previousOrders,
      currentOrders: currentOrders ?? this.currentOrders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
