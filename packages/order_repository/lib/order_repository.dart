import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:order_repository/models/category.dart';

import 'models/order.dart';
import 'models/product.dart';

abstract class OrderRepository {
  Stream<List<Order>> orders(
      {List<OrderStatus> orderStatus,
      DateTime start,
      DateTime stop,
      String userId});

  Stream<List<Product>> products();

  Future<void> addCategory(Category category);

  Future<Product> getProduct(
    String categoryId,
    String productId, {
    bool loadImage = true,
  });

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(Category category);

  Future<void> addProduct(Category category, Product product);

  Future<void> removeProduct(Category category, Product product);

  Future<void> updateProductAvailability(
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

  Future<ImageProvider> getProductImage(String productId);

  Future<void> setProductImage(Product product, Uint8List data);
}
