import 'package:allocrepes/allo/order_admin/cubit/order_admin_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

class OrderAdminCubit extends Cubit<OrderAdminState> {
  OrderAdminCubit(this._authenticationRepository, this._orderRepository)
      : super(const OrderAdminState()) {
    getOrders();
  }

  final OrderRepository _orderRepository;
  final AuthenticationRepository _authenticationRepository;

  void getOrders() {
    OrderStatus.values.forEach((status) {
      _orderRepository.orders(orderStatus: [status]).forEach(
          (orders) => _changeOrderList(status, orders));
    });
  }

  void _changeOrderList(OrderStatus status, List<Order> orders) {
    Map<OrderStatus, List<Order>> ordersMap = {};
    ordersMap.addAll(state.orders);
    ordersMap[status] = orders;
    emit(state.copyWith(orders: ordersMap));
  }

  Future<Product> getProduct(Article article) {
    return _orderRepository.getProduct(
      article.categoryId,
      article.productId,
      loadImage: false,
    );
  }

  Future<User> getUser(String user) {
    return _authenticationRepository.getUserFromUid(user);
  }

  void expandOrder(Order order, bool expand) {
    Map<String, bool> expandedOrders = {};
    expandedOrders.addAll(state.expandedOrders);

    expandedOrders[order.id] = expand;

    emit(state.copyWith(expandedOrders: expandedOrders));
  }

  void updateOrderStatus(Order order, OrderStatus status) {
    _orderRepository.editOrder(order.copyWith(status: status));
  }
}
