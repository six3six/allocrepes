import 'dart:async';

import 'package:order_repository/models/category.dart';

import 'models/order.dart';
import 'models/place.dart';
import 'models/product.dart';

abstract class OrderRepository {
  void changeUser(String userId);

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

  Future<void> updateProductName(
      Category category, String productId, String name);

  Future<void> removeProduct(Category category, String productId);

  Future<void> updateProductAvailability(
    Category category,
    Product product,
    bool available,
  );

  Future<void> updateProductAvailabilityESIEE(
    Category category,
    Product product,
    bool available,
  );

  Future<void> updateProductOneOrder(
    Category category,
    Product product,
    bool oneOrder,
  );

  Future<void> updateProductMaxAmount(
    Category category,
    String productId,
    int maxAmount,
  );

  Future<void> updateProductInitialStock(
    Category category,
    String productId,
    int initialStock,
  );

  Stream<List<Product>> productsFromCategory(
    Category category, {
    bool? available,
    bool? availableESIEE,
  });

  Stream<List<Category>> categories();

  Stream<List<Order>> orders({
    List<OrderStatus>? orderStatus,
    List<Place>? places,
    DateTime? start,
    DateTime? stop,
    String? userId,
  });

  Stream<List<Order>> userOrders({
    List<OrderStatus>? orderStatus,
  });

  Stream<Order> order(String id);

  Future<void> createOrder(Order order);

  Future<void> editOrder(Order order);

  Future<void> cancelOrder(Order order);
}
