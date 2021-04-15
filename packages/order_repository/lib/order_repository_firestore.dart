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
import 'models/place.dart';
import 'models/product.dart';

class OrderRepositoryFirestore extends OrderRepository {
  static final CollectionReference orderRoot =
      FirebaseFirestore.instance.collection("orders");

  static final CollectionReference productCategoryRoot =
      FirebaseFirestore.instance.collection("product_categories");

  static final Query productGroupRoot =
      FirebaseFirestore.instance.collectionGroup("products");

  static final ruleRoot = FirebaseFirestore.instance.collection("rules");

  @override
  Stream<bool> showOrderPages() {
    final showOrder = ruleRoot.doc("show_order");
    return showOrder.snapshots().map((snap) => snap.data()?["enable"] ?? false);
  }

  Future<void> changeOrderPagesView(bool shown) {
    return ruleRoot.doc("show_order").update({
      "enable": shown,
    });
  }

  @override
  Future<void> createOrder(Order order) async {
    final orderRef = await orderRoot.add(order.toEntity().toDocument());
    final articlesRef = orderRef.collection("articles");
    for (Article article in order.articles) {
      articlesRef.add(article.toEntity().toDocument());
    }
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
    await for (DocumentSnapshot doc in orderRoot.doc(id).snapshots()) {
      yield await _orderFromEntity(OrderEntity.fromSnapshot(doc));
    }
  }

  @override
  Stream<List<Product>> products() async* {
    await for (final snapshot in productGroupRoot.snapshots()) {
      yield await productsFromSnapshot(snapshot);
    }
  }

  @override
  Stream<List<Product>> productsFromCategory(
    Category category, {
    bool? available,
  }) async* {
    Query query = productCategoryRoot.doc(category.id).collection("products");
    if (available != null) {
      query = query.where(
        "available",
        isEqualTo: available,
      );
    }
    await for (final snapshot in query.snapshots()) {
      yield await productsFromSnapshot(snapshot);
    }
  }

  Future<List<Product>> productsFromSnapshot(QuerySnapshot snapshot) async {
    List<Product> products = [];
    for (final doc in snapshot.docs) {
      Product product = Product.fromEntity(ProductEntity.fromSnapshot(doc));

      products.add(product);
    }

    return products;
  }

  @override
  Stream<List<Category>> categories() {
    return productCategoryRoot.snapshots().map<List<Category>>(
          (QuerySnapshot snapshot) => snapshot.docs
              .map((e) => Category.fromEntity(CategoryEntity.fromSnapshot(e)))
              .toList(),
        );
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
    List<OrderStatus>? orderStatus,
    List<Place>? places,
    DateTime? start,
    DateTime? stop,
    String? userId,
  }) async* {
    Query query = orderRoot;

    if (orderStatus != null) {
      query = query.where(
        "status",
        whereIn: orderStatus.map((e) => e.index).toList(),
      );
    }

    if (userId != null)
      query = query.where(
        "owner",
        isEqualTo: userId,
      );

    if (start != null)
      query = query.where("create_at", isGreaterThanOrEqualTo: start);
    if (stop != null)
      query = query.where("create_at", isLessThanOrEqualTo: start);

    await for (QuerySnapshot snapshot in query.snapshots()) {
      List<Order> orders = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final order = await _orderFromEntity(OrderEntity.fromSnapshot(doc));

        if (places != null && !places.map((e) => e).contains(order.place))
          continue;
        orders.add(order);
      }
      orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
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

      return Article.fromEntity(entity);
    }).toList();

    return Order.fromEntity(entity, articles);
  }

  Future<void> removeOrders({
    List<OrderStatus>? orderStatus,
  }) async {
    Query query = orderRoot;
    if (orderStatus != null) {
      query = query.where(
        "status",
        whereIn: orderStatus.map((e) => e.index).toList(),
      );
    }
    await query.get().then((snapshot) => snapshot.docs.forEach((doc) async {
          final articles = await doc.reference.collection("articles").get();
          for (final article in articles.docs) {
            await article.reference.delete();
          }
          doc.reference.delete();
        }));
  }

  @override
  Future<void> addCategory(Category category) {
    return productCategoryRoot.add(category.toEntity().toDocument());
  }

  @override
  Future<Product> getProduct(
    String categoryId,
    String productId,
  ) async {
    final snapshot = await productCategoryRoot
        .doc(categoryId)
        .collection("products")
        .doc(productId)
        .get();

    return Product.fromEntity(ProductEntity.fromSnapshot(snapshot));
  }

  @override
  Future<void> updateCategory(Category category) => productCategoryRoot
      .doc(category.id)
      .update(category.toEntity().toDocument());

  @override
  Future<void> deleteCategory(Category category) async {
    await productCategoryRoot.doc(category.id).delete();
  }

  @override
  Future<void> addProduct(Category category, Product product) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .add(product.toEntity().toDocument());
  }

  Future<void> removeProduct(Category category, Product product) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .doc(product.id)
        .delete();
  }

  @override
  Future<void> updateProductAvailability(
    Category category,
    Product product,
    bool available,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .doc(product.id)
        .update({"available": available});
  }

  Future<void> updateProductMaxAmount(
    Category category,
    Product product,
    int maxAmount,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .doc(product.id)
        .update({"maxAmount": maxAmount});
  }

  Future<void> updateProductInitialStock(
    Category category,
    Product product,
    int initialStock,
  ) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .doc(product.id)
        .update({"initialStock": initialStock});
  }
}
