import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';

class OrderListState extends Equatable {
  final List<Order> previousOrders;
  final List<Order> currentOrders;
  final bool isLoading;
  final bool isConnected;

  const OrderListState({
    this.previousOrders = const [],
    this.currentOrders = const [],
    this.isLoading = true,
    this.isConnected = false,
  });

  @override
  List<Object> get props => [
        isLoading,
        isConnected,
      ]
        ..addAll(previousOrders)
        ..addAll(currentOrders);

  OrderListState copyWith({
    List<Order>? previousOrders,
    List<Order>? currentOrders,
    bool? isLoading,
    bool? isConnected,
  }) {
    return OrderListState(
      previousOrders: previousOrders ?? this.previousOrders,
      currentOrders: currentOrders ?? this.currentOrders,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
