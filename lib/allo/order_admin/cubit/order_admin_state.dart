import 'package:equatable/equatable.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderAdminState extends Equatable {
  const OrderAdminState({
    this.orders = const {},
    this.selectedStatus = const {},
    this.selectedPlaces = const {},
    this.products = const {},
  });

  final Map<Place, bool> selectedPlaces;
  final Map<OrderStatus, bool> selectedStatus;
  final Map<OrderStatus, List<Order>> orders;
  final Map<String, Product> products;

  @override
  List<Object> get props => [
        ...selectedPlaces.keys,
        ...selectedPlaces.values,
        ...selectedStatus.keys,
        ...selectedStatus.values,
        ...orders.keys,
        ...orders.values,
        ...products.keys,
        ...products.values,
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
      selectedPlaces: selectedPlaces ?? this.selectedPlaces,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      products: products ?? this.products,
    );
  }

  Map<OrderStatus, List<Order>> getOrders() {
    var orders = <OrderStatus, List<Order>>{};
    var status = selectedStatus.keys.where(
      (status) => selectedStatus[status] ?? false,
    );

    for (var s in status) {
        orders[s] = this
                .orders[s]
                ?.where((order) => selectedPlaces[order.place] ?? false)
                .toList() ??
            [];
      }
    return orders;
  }
}
