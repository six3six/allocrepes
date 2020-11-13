import 'dart:async';

import 'package:order_repository/models/category.dart';

import 'models/order.dart';
import 'models/product.dart';

abstract class OrderRepository {
  Stream<List<Order>> orders(
      {bool delivered, DateTime start, DateTime stop, String userId});

  Stream<List<Product>> products();

  Future<void> addCategory(Category category);

  Future<void> addProduct(Category category, Product product);

  Future<void> changeAvailability(
    Category category,
    Product product,
    bool available,
  );

  Stream<List<Product>> productsFromCategory(Category category);

  Stream<List<Category>> categories();

  Stream<Map<Category, Stream<List<Product>>>> productByCategory();

  Stream<Order> order(String id);

  Future<void> createOrder(Order order);

  Future<void> editOrder(Order order);

  Future<void> cancelOrder(Order order);
}
