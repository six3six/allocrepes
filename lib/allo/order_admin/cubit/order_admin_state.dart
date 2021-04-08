import 'package:equatable/equatable.dart';
import 'package:order_repository/models/article.dart';
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
  List<Object> get props => [
        orders.keys.toList(),
        orders.values.toList(),
        expandedOrders.keys.toList(),
        expandedOrders.values.toList(),
        selectedStatus.keys.toList(),
        selectedStatus.values.toList(),
        selectedPlaces.keys.toList(),
        selectedPlaces.values.toList(),
        products.keys.toList(),
        products.values.toList(),
      ];

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
