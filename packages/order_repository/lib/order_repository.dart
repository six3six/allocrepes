import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:order_repository/models/category.dart';

import 'models/order.dart';
import 'models/place.dart';
import 'models/product.dart';

abstract class OrderRepository {
  Stream<List<Order>> orders({
    List<OrderStatus>? orderStatus,
    List<Place>? places,
    DateTime? start,
    DateTime? stop,
    String? userId,
  });

  Future<void> removeOrders({
    List<OrderStatus>? orderStatus,
  });

  Stream<List<Product>> products();

  Future<void> addCategory(Category category);

  Future<Product> getProduct(
    String categoryId,
    String productId,
  );

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(Category category);

  Future<void> addProduct(Category category, Product product);

  Future<void> removeProduct(Category category, Product product);



  Future<void> updateProductAvailability(
    Category category,
    Product product,
    bool available,
  );

  Future<void> updateProductMaxAmount(
    Category category,
    Product product,
    int maxAmount,
  );

  Future<void> updateProductInitialStock(
      Category category,
      Product product,
      int initialStock,
      );

  Stream<List<Product>> productsFromCategory(
    Category category, {
    bool? available,
  });

  Stream<List<Category>> categories();

  Stream<Map<Category, Stream<List<Product>>>> productByCategory();

  Stream<Order> order(String id);

  Future<void> createOrder(Order order);

  Future<void> editOrder(Order order);

  Future<void> cancelOrder(Order order);

}
