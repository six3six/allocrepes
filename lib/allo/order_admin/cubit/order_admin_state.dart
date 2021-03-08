import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';

class OrderAdminState extends Equatable {
  const OrderAdminState({
    this.orders = const {},
    this.expandedOrders = const {},
  });

  final Map<OrderStatus, List<Order>> orders;

  final Map<String, bool> expandedOrders;

  @override
  List<Object> get props => [
        orders.keys.toList(),
        orders.values.toList(),
        expandedOrders.keys.toList(),
        expandedOrders.values.toList(),
      ];

  OrderAdminState copyWith(
      {Map<OrderStatus, List<Order>> orders,
      Map<String, bool> expandedOrders}) {
    return OrderAdminState(
      orders: orders ?? this.orders,
      expandedOrders: expandedOrders ?? this.expandedOrders,
    );
  }
}
