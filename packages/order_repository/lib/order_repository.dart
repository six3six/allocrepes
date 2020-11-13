import 'dart:async';

import 'package:order_repository/models/category.dart';

import 'models/order.dart';
import 'models/product.dart';

abstract class OrderRepository {
  Stream<List<Order>> orders(
      {bool delivered, DateTime start, DateTime stop, String userId});

  Stream<List<Product>> products();

  Stream<List<Product>> productsFromCategory(Category category);

  Stream<List<Category>> categories();

  Stream<Map<Category, Stream<List<Product>>>> productByCategory();

  Stream<Order> order(String id);

  void createOrder(Order order);

  void editOrder(Order order);

  void cancelOrder(Order order);
}
