import 'package:allocrepes/allo/order_admin/cubit/order_admin_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

class OrderAdminCubit extends Cubit<OrderAdminState> {
  OrderAdminCubit(
    this._authenticationRepository,
    this._orderRepository,
    this.fast,
  ) : super(
          OrderAdminState(
            selectedPlaces: Place.values.asMap().map(
                  (key, value) => MapEntry(value, true),
                ),
            selectedStatus: OrderStatus.values.asMap().map(
                  (key, value) => MapEntry(
                      value,
                      !(value == OrderStatus.UNKNOWN ||
                          value == OrderStatus.DELIVERED ||
                          value == OrderStatus.CANCELED)),
                ),
          ),
        ) {
    getOrders();
  }

  final bool fast;
  final OrderRepository _orderRepository;
  final AuthenticationRepository _authenticationRepository;

  void getOrders() {
    _orderRepository.products().forEach((products) {
      var productsMap = <String, Product>{};
      for (var product in products) {
        productsMap[product.id ?? ''] = product;
      }
      emit(state.copyWith(products: productsMap));
    });

    (!fast
            ? _orderRepository.orders()
            : _orderRepository.orders(
                start: DateTime.now().subtract(
                  const Duration(hours: 1),
                ),
              ))
        .forEach((orders) {
      var ordersMap = <OrderStatus, List<Order>>{};
      for (var order in orders) {
        if (!ordersMap.containsKey(order.status)) {
          ordersMap[order.status] = [];
        }
        ordersMap[order.status]?.add(order);
      }

      emit(state.copyWith(orders: ordersMap));
    });
  }

  Future<User> getUser(String user) async {
    return (await _authenticationRepository
            .getUserFromID(user.toLowerCase())) ??
        User.empty;
  }

  void updateOrderStatus(Order order, OrderStatus status) {
    _orderRepository.editOrder(order.copyWith(status: status));
  }

  void updateFilterStatus(OrderStatus status, bool activate) {
    emit(state.copyWith(
      selectedStatus: {}
        ..addAll(state.selectedStatus)
        ..[status] = activate,
    ));
  }

  void updateFilterRoom(Place place, bool activate) {
    emit(state.copyWith(
      selectedPlaces: {}
        ..addAll(state.selectedPlaces)
        ..[place] = activate,
    ));
  }
}
