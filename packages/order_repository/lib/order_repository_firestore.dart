import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_repository/entities/article_entity.dart';
import 'package:order_repository/entities/category_entity.dart';
import 'package:order_repository/entities/order_entity.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/order.dart' as order_model;
import 'package:order_repository/order_repository.dart';

import 'entities/product_entity.dart';
import 'models/article.dart';
import 'models/order_status.dart';
import 'models/place.dart';
import 'models/product.dart';

class OrderRepositoryFirestore extends OrderRepository {
  static final CollectionReference orderRoot =
      FirebaseFirestore.instance.collection('orders');

  static final CollectionReference productCategoryRoot =
      FirebaseFirestore.instance.collection('product_categories');

  static final Query productGroupRoot =
      FirebaseFirestore.instance.collectionGroup('products');

  String userId = '';

  List<Product> _products = [];
  List<Category> _categories = [];
  final Map<Category, List<Product>> _productFromCategory = {};

  OrderRepositoryFirestore() {
    products().forEach((products) {
      _products = products;
    });

    categories().forEach((categories) {
      _categories = categories;
      _categories.forEach((category) {
        productsFromCategory(category).forEach((n) => null);
      });
    });
  }

  Stream<List<order_model.Order>>? _streamUserOrder;
  List<order_model.Order> _userOrders = [];

  @override
  void changeUser(String userId) {
    this.userId = userId;

    _streamUserOrder = null;
    _streamUserOrder = orders(userId: userId);

    _streamUserOrder?.forEach((orders) {
      _userOrders = orders;
    });
  }

  @override
  Stream<List<order_model.Order>> userOrders({
    List<OrderStatus>? orderStatus,
  }) async* {
    if (orderStatus != null) {
      yield _userOrders
          .where((order) => orderStatus.contains(order.status))
          .toList();
    } else {
      yield _userOrders;
    }

    await for (List<order_model.Order> orders
        in orders(userId: userId, orderStatus: orderStatus)) {
      yield orders;
    }
  }

  /*
  ------ ORDERS ------
  */
  @override
  Future<void> createOrder(order_model.Order order) async {
    final orderRef = await orderRoot.add(order.toEntity().toDocument());
    final articlesRef = orderRef.collection('articles');
    for (var article in order.articles) {
      await articlesRef.add(article.toEntity().toDocument());
    }
  }

  @override
  Future<void> editOrder(order_model.Order order) async {
    await orderRoot.doc(order.id).set(order.toEntity().toDocument());

    final articlesRef = orderRoot.doc(order.id).collection('articles');
    var articleList = await articlesRef.get();

    articleList.docs.map((doc) => articlesRef.doc(doc.id).delete());

    order.articles.map((Article article) =>
        articlesRef.doc(article.id).set(article.toEntity().toDocument()));
  }

  @override
  Future<void> cancelOrder(order_model.Order order) async {
    await orderRoot
        .doc(order.id)
        .update({'status': OrderStatus.CANCELED.index});
  }

  @override
  Stream<order_model.Order> order(String id) async* {
    await for (DocumentSnapshot doc in orderRoot.doc(id).snapshots()) {
      yield await _orderFromEntity(OrderEntity.fromSnapshot(doc));
    }
  }

  @override
  Stream<List<order_model.Order>> orders({
    List<OrderStatus>? orderStatus,
    List<Place>? places,
    DateTime? start,
    DateTime? stop,
    String? userId,
  }) async* {
    Query query = orderRoot;
    if (orderStatus != null) {
      query = query.where(
        'status',
        whereIn: orderStatus.map((e) => e.index).toList(),
      );
    }

    if (userId != null) {
      query = query.where(
        'owner',
        isEqualTo: userId,
      );
    }

    if (start != null) {
      query = query.where(
        'created_at',
        isGreaterThanOrEqualTo: start,
      );
    }
    if (stop != null) {
      query = query.where(
        'created_at',
        isLessThanOrEqualTo: start,
      );
    }

    await for (QuerySnapshot snapshot in query.snapshots()) {
      var orders = <order_model.Order>[];

      for (var doc in snapshot.docs) {
        final order = await _orderFromEntity(OrderEntity.fromSnapshot(doc));

        if (places != null && !places.contains(order.place)) {
          continue;
        }
        orders.add(order);
      }
      orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      yield orders;
    }
  }

  Future<order_model.Order> _orderFromEntity(OrderEntity entity) async {
    final articlesRef = orderRoot.doc(entity.id).collection('articles');
    final querySnapshot = await articlesRef.get();
    var articles = querySnapshot.docs.map((QueryDocumentSnapshot doc) {
      final entity = ArticleEntity.fromSnapshot(doc);

      return Article.fromEntity(entity);
    }).toList();

    return order_model.Order.fromEntity(entity, articles);
  }

  @override
  Future<void> removeOrders({
    List<OrderStatus>? orderStatus,
  }) async {
    Query query = orderRoot;
    if (orderStatus != null) {
      query = query.where(
        'status',
        whereIn: orderStatus.map((e) => e.index).toList(),
      );
    }
    await query.get().then((snapshot) => snapshot.docs.forEach((doc) async {
          final articles = await doc.reference.collection('articles').get();
          for (final article in articles.docs) {
            await article.reference.delete();
          }
          await doc.reference.delete();
        }));
  }

  @override
  Future<void> updateProductAvailability(
    Category category,
    Product product,
    bool available,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(product.id)
        .update({'available': available});
  }

  @override
  Future<void> updateProductAvailabilityESIEE(
    Category category,
    Product product,
    bool available,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(product.id)
        .update({'available_esiee': available});
  }

  @override
  Future<void> updateProductOneOrder(
    Category category,
    Product product,
    bool oneOrder,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(product.id)
        .update({'one_order': oneOrder});
  }

  @override
  Future<void> updateProductMaxAmount(
    Category category,
    String productId,
    int maxAmount,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(productId)
        .update({'maxAmount': maxAmount});
  }

  @override
  Future<void> updateProductInitialStock(
    Category category,
    String productId,
    int initialStock,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(productId)
        .update({'initialStock': initialStock});
  }

/*
  ------ PRODUCTS ------
  */
  @override
  Stream<List<Product>> products() async* {
    yield _products;
    await for (final snapshot in productGroupRoot.snapshots()) {
      yield await productsFromSnapshot(snapshot);
    }
  }

  @override
  Stream<List<Product>> productsFromCategory(
    Category category, {
    bool? available,
    bool? availableESIEE,
  }) async* {
    if (available != null) {
      yield _productFromCategory[category]
              ?.where((product) => product.available == available)
              .toList() ??
          [];
    }

    if (availableESIEE != null) {
      yield _productFromCategory[category]
              ?.where((product) => product.availableESIEE == availableESIEE)
              .toList() ??
          [];
    } else {
      yield _productFromCategory[category] ?? [];
    }
    Query query = productCategoryRoot.doc(category.id).collection('products');
    if (available != null) {
      query = query.where(
        'available',
        isEqualTo: available,
      );
    }
    if (availableESIEE != null) {
      query = query.where(
        'available_esiee',
        isEqualTo: availableESIEE,
      );
    }
    await for (final snapshot in query.snapshots()) {
      final products = await productsFromSnapshot(snapshot);
      _productFromCategory[category] = products;
      yield products;
    }
  }

  Future<List<Product>> productsFromSnapshot(QuerySnapshot snapshot) async {
    var products = <Product>[];
    for (final doc in snapshot.docs) {
      var product = Product.fromEntity(ProductEntity.fromSnapshot(doc));

      products.add(product);
    }

    return products;
  }

  @override
  Future<Product> getProduct(
    String categoryId,
    String productId,
  ) async {
    final snapshot = await productCategoryRoot
        .doc(categoryId)
        .collection('products')
        .doc(productId)
        .get();

    return Product.fromEntity(ProductEntity.fromSnapshot(snapshot));
  }

  @override
  Future<void> addProduct(Category category, Product product) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .add(product.toEntity().toDocument());
  }

  @override
  Future<void> updateProductName(
      Category category, String productId, String name) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(productId)
        .update({'name': name});
  }

  @override
  Future<void> removeProduct(Category category, String productId) {
    return productCategoryRoot
        .doc(category.id)
        .collection('products')
        .doc(productId)
        .delete();
  }

/*
  ------ CATEGORIES ------
  */

  @override
  Stream<List<Category>> categories() async* {
    yield _categories;

    final snapshots = productCategoryRoot.snapshots();
    await for (QuerySnapshot snapshot in snapshots) {
      yield snapshot.docs
          .map((e) => Category.fromEntity(CategoryEntity.fromSnapshot(e)))
          .toList();
    }
  }

  @override
  Future<void> addCategory(Category category) {
    return productCategoryRoot.add(category.toEntity().toDocument());
  }

  @override
  Future<void> updateCategory(Category category) => productCategoryRoot
      .doc(category.id)
      .update(category.toEntity().toDocument());

  @override
  Future<void> deleteCategory(Category category) async {
    await productCategoryRoot.doc(category.id).delete();
  }
}
