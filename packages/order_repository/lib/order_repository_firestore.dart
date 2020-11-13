import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_repository/entities/article_entity.dart';
import 'package:order_repository/entities/category_entity.dart';
import 'package:order_repository/entities/order_entity.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/order_repository.dart';

import 'entities/product_entity.dart';
import 'models/article.dart';
import 'models/order_status.dart';
import 'models/product.dart';

class OrderRepositoryFirestore extends OrderRepository {
  final CollectionReference orderRoot =
      FirebaseFirestore.instance.collection("orders");

  final CollectionReference productCategoryRoot =
      FirebaseFirestore.instance.collection("product_categories");

  final Query productGroupRoot =
      FirebaseFirestore.instance.collectionGroup("products");

  List<Product> productList = [];

  OrderRepositoryFirestore() {
    products().listen((List<Product> products) => productList = products);
  }

  @override
  Future<Order> createOrder(Order order) async {
    final orderRef = await orderRoot.add(order.toEntity().toDocument());
    final articlesRef = orderRef.collection("articles");
    for (Article article in order.articles) {
      articlesRef.add(article.toEntity().toDocument());
    }
    return this.order(orderRef.id).first;
  }

  @override
  Future<void> editOrder(Order order) async {
    orderRoot.doc(order.id).set(order.toEntity().toDocument());

    final CollectionReference articlesRef =
        orderRoot.doc(order.id).collection("articles");
    QuerySnapshot articleList = await articlesRef.get();

    articleList.docs.map((doc) => articlesRef.doc(doc.id).delete());

    order.articles.map((Article article) =>
        articlesRef.doc(article.id).set(article.toEntity().toDocument()));
  }

  @override
  Future<void> cancelOrder(Order order) async {
    await orderRoot
        .doc(order.id)
        .update({"status": OrderStatus.CANCELED.index});
  }

  @override
  Stream<Order> order(String id) async* {
    await for (DocumentSnapshot doc in orderRoot.doc("id").snapshots()) {
      yield await _orderFromEntity(OrderEntity.fromSnapshot(doc));
    }
  }

  @override
  Stream<List<Product>> products() {
    return productGroupRoot.snapshots().map<List<Product>>(
            (QuerySnapshot snapshot) =>
            snapshot.docs
                .map<Product>((QueryDocumentSnapshot doc) =>
                Product.fromEntity(ProductEntity.fromSnapshot(doc)))
                .toList());
  }

  @override
  Stream<List<Product>> productsFromCategory(Category category) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .snapshots()
        .map<List<Product>>((QuerySnapshot snapshot) =>
        snapshot.docs
            .map<Product>((QueryDocumentSnapshot doc) =>
            Product.fromEntity(ProductEntity.fromSnapshot(doc)))
            .toList());
  }

  @override
  Stream<List<Category>> categories() {
    return productCategoryRoot.snapshots().map<List<Category>>(
            (QuerySnapshot snapshot) =>
            snapshot.docs
                .map((e) => Category.fromEntity(CategoryEntity.fromSnapshot(e)))
                .toList());
  }

  @override
  Stream<Map<Category, Stream<List<Product>>>> productByCategory() async* {
    await for (List<Category> categories in categories()) {
      Map<Category, Stream<List<Product>>> result =
      Map<Category, Stream<List<Product>>>();

      for (Category category in categories) {
        result[category] = productsFromCategory(category);
      }

      yield result;
    }
  }

  @override
  Stream<List<Order>> orders({
    bool delivered,
    DateTime start,
    DateTime stop,
    String userId,
  }) async* {
    Query query = orderRoot.orderBy("created_at");
    if (delivered == false)
      query = query.where("status", isNotEqualTo: OrderStatus.DELIVERED);
    else if (delivered == true)
      query = query.where("status", isEqualTo: OrderStatus.DELIVERED);

    if (userId != null) query = query.where("owner", isEqualTo: userId);

    if (start != null)
      query = query.where("create_at", isGreaterThanOrEqualTo: start);
    if (stop != null)
      query = query.where("create_at", isLessThanOrEqualTo: start);

    await for (QuerySnapshot snapshot in query.snapshots()) {
      List<Order> orders = List<Order>(snapshot.docs.length);

      int i = 0;
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        orders[i] = await _orderFromEntity(OrderEntity.fromSnapshot(doc));
        i++;
      }

      yield orders;
    }
  }

  Future<Order> _orderFromEntity(OrderEntity entity) async {
    final CollectionReference articlesRef =
    orderRoot.doc(entity.id).collection("articles");
    final QuerySnapshot querySnapshot = await articlesRef.get();
    List<Article> articles =
    querySnapshot.docs.map((QueryDocumentSnapshot doc) {
      final ArticleEntity entity = ArticleEntity.fromSnapshot(doc);
      return Article.fromEntity(entity, _itemById(entity.item));
    }).toList();

    return Order.fromEntity(entity, articles);
  }

  Product _itemById(String id) {
    for (Product product in productList) {
      if (product.id == id) return product;
    }
    return null;
  }

  @override
  Future<void> addCategory(Category category) async {
    await productCategoryRoot.add(category.toEntity().toDocument());
  }

  @override
  Future<void> addProduct(Category category, Product product) async {
    await productCategoryRoot
        .doc(category.id)
        .collection("products")
        .add(product.toEntity().toDocument());
  }

  @override
  Future<void> changeAvailability(Category category, Product product,
      bool available) async {
    await productCategoryRoot
        .doc(category.id)
        .collection("products")
        .doc(product.id)
        .update({"available": available});
  }
}
