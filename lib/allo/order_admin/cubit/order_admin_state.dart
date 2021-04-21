import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderAdminState extends Equatable {
  const OrderAdminState({
    this.orders = const {},
    this.selectedStatus = const {},
    this.selectedPlaces = const {},
    this.expandedOrders = const {},
    this.products = const {},
  });

  final Map<Place, bool> selectedPlaces;
  final Map<OrderStatus, bool> selectedStatus;
  final Map<OrderStatus, List<Order>> orders;
  final Map<String, bool> expandedOrders;
  final Map<String, Product> products;

  @override
  List<Object> get props => []
    ..addAll(selectedPlaces.keys)
    ..addAll(selectedPlaces.values)
    ..addAll(selectedStatus.keys)
    ..addAll(selectedStatus.values)
    ..addAll(orders.keys)
    ..addAll(orders.values)
    ..addAll(expandedOrders.keys)
    ..addAll(expandedOrders.values)
    ..addAll(products.keys)
    ..addAll(products.values);

  OrderAdminState copyWith({
    Map<OrderStatus, List<Order>>? orders,
    Map<String, bool>? expandedOrders,
    Map<OrderStatus, bool>? selectedStatus,
    Map<Place, bool>? selectedPlaces,
    Map<String, Product>? products,
  }) {
    return OrderAdminState(
      orders: orders ?? this.orders,
      expandedOrders: expandedOrders ?? this.expandedOrders,
      selectedPlaces: selectedPlaces ?? this.selectedPlaces,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      products: products ?? this.products,
    );
  }
}
