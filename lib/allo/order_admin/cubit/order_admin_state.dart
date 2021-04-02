import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';

class OrderAdminState extends Equatable {
  const OrderAdminState({
    this.orders = const {},
    this.selectedStatus = const {},
    this.selectedPlaces = const {},
    this.expandedOrders = const {},
  });

  final Map<Place, bool> selectedPlaces;
  final Map<OrderStatus, bool> selectedStatus;
  final Map<OrderStatus, List<Order>> orders;
  final Map<String, bool> expandedOrders;

  @override
  List<Object> get props => [
        orders.keys.toList(),
        orders.values.toList(),
        expandedOrders.keys.toList(),
        expandedOrders.values.toList(),
        selectedStatus.keys.toList(),
        selectedStatus.values.toList(),
        selectedPlaces.keys.toList(),
        selectedPlaces.values.toList(),
      ];

  OrderAdminState copyWith({
    Map<OrderStatus, List<Order>>? orders,
    Map<String, bool>? expandedOrders,
    Map<OrderStatus, bool>? selectedStatus,
    Map<Place, bool>? selectedPlaces,
  }) {
    return OrderAdminState(
      orders: orders ?? this.orders,
      expandedOrders: expandedOrders ?? this.expandedOrders,
      selectedPlaces: selectedPlaces ?? this.selectedPlaces,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}
