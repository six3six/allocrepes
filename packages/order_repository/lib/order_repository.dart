import 'dart:async';

import 'models/order.dart';

abstract class OrderRepository {
  Stream<List<Order>> orders({bool delivered, DateTime start, DateTime stop});

  Stream<Order> order(String id);

  void createOrder(Order order);

  void editOrder(Order order);

  void cancelOrder(Order order);
}
