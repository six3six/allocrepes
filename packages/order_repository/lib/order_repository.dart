import 'dart:async';

import 'models/item.dart';
import 'models/order.dart';

abstract class OrderRepository {
  Stream<List<Order>> orders(
      {bool delivered, DateTime start, DateTime stop, String userId});

  Stream<List<Item>> items();

  Stream<Order> order(String id);

  void createOrder(Order order);

  void editOrder(Order order);

  void cancelOrder(Order order);
}
