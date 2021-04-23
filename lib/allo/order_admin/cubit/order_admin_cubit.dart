import 'package:allocrepes/allo/order_admin/cubit/order_admin_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

class OrderAdminCubit extends Cubit<OrderAdminState> {
  OrderAdminCubit(this._authenticationRepository, this._orderRepository)
      : super(
          OrderAdminState(
            selectedPlaces: Place.values.asMap().map(
                  (key, value) => MapEntry(value, true),
                ),
            selectedStatus: OrderStatus.values.asMap().map(
                  (key, value) => MapEntry(value, true),
                ),
          ),
        ) {
    getOrders();
    _orderRepository.products().forEach((products) {
      var productsMap = <String, Product>{};
      products.forEach((product) {
        productsMap[product.id ?? ''] = product;
      });
      emit(state.copyWith(products: productsMap));
    });
  }

  final OrderRepository _orderRepository;
  final AuthenticationRepository _authenticationRepository;

  Stream<List<Order>>? orderStream;

  void getOrders() {
    orderStream = null;

    final status = <OrderStatus>[];
    state.selectedStatus.forEach((sStatus, selected) {
      if (selected) status.add(sStatus);
    });

    final places = <Place>[];
    state.selectedPlaces.forEach((sPlaces, selected) {
      if (selected) places.add(sPlaces);
    });

    orderStream = _orderRepository.orders(orderStatus: status, places: places);

    orderStream?.forEach((orders) {
      var ordersMap = <OrderStatus, List<Order>>{};
      orders.forEach((order) {
        if (!ordersMap.containsKey(order.status)) ordersMap[order.status] = [];
        ordersMap[order.status]?.add(order);
      });

      emit(state.copyWith(orders: ordersMap));
    });
  }

  Future<User> getUser(String user) {
    return _authenticationRepository.getUserFromUid(user.toLowerCase());
  }

  void expandOrder(Order order, bool expand) {
    var expandedOrders = <String, bool>{};
    expandedOrders.addAll(state.expandedOrders);

    expandedOrders[order.id!] = expand;

    emit(state.copyWith(expandedOrders: expandedOrders));
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
    getOrders();
  }

  void updateFilterRoom(Place place, bool activate) {
    emit(state.copyWith(
      selectedPlaces: {}
        ..addAll(state.selectedPlaces)
        ..[place] = activate,
    ));
    getOrders();
  }
}
