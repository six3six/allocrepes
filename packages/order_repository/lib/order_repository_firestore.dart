import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/image.dart';
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

  static final _productImageBase =
      FirebaseStorage.instance.ref().child("products").child("images");

  List<Place> places() {
    return [
      Place(name: "Ampère A"),
      Place(name: "Ampère B"),
      Place(name: "Ampère C"),
      Place(name: "Arago"),
    ];
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
  Stream<List<Product>> productsFromCategory(Category category) async* {
    await for (final snapshot in productCategoryRoot
        .doc(category.id)
        .collection("products")
        .snapshots()) {
      yield await productsFromSnapshot(snapshot);
    }
  }

  Future<List<Product>> productsFromSnapshot(QuerySnapshot snapshot) async {
    List<Product> products = [];
    for (final doc in snapshot.docs) {
      Product product = Product.fromEntityWithImage(
          ProductEntity.fromSnapshot(doc), await getProductImage(doc.id));

      products.add(product);
    }

    return products;
  }

  @override
  Stream<List<Category>> categories() {
    return productCategoryRoot.snapshots().map<List<Category>>(
        (QuerySnapshot snapshot) => snapshot.docs
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
    List<OrderStatus> orderStatus,
    List<Place> places,
    DateTime start,
    DateTime stop,
    String userId,
  }) async* {
    Query query = orderRoot.limit(10000);

    if (orderStatus != null) {
      query = query.where("status",
          whereIn: orderStatus.map((e) => e.index).toList());
    }

    if (userId != null) query = query.where("owner", isEqualTo: userId);

    if (start != null)
      query = query.where("create_at", isGreaterThanOrEqualTo: start);
    if (stop != null)
      query = query.where("create_at", isLessThanOrEqualTo: start);

    query.orderBy("create_at", descending: false);

    print(query.parameters);

    await for (QuerySnapshot snapshot in query.snapshots()) {
      List<Order> orders = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final order = await _orderFromEntity(OrderEntity.fromSnapshot(doc));

        if (places != null && !places.map((e) => e.name).contains(order.place))
          continue;
        orders.add(order);
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
      return Article.fromEntity(entity);
    }).toList();

    return Order.fromEntity(entity, articles);
  }

  @override
  Future<void> addCategory(Category category) {
    return productCategoryRoot.add(category.toEntity().toDocument());
  }

  @override
  Future<Product> getProduct(
    String categoryId,
    String productId, {
    bool loadImage = true,
  }) async {
    final snapshot = await productCategoryRoot
        .doc(categoryId)
        .collection("products")
        .doc(productId)
        .get();
    if (loadImage) {
      final image = await getProductImage(productId);
      return Product.fromEntityWithImage(
          ProductEntity.fromSnapshot(snapshot), image);
    } else
      return Product.fromEntity(ProductEntity.fromSnapshot(snapshot));
  }

  @override
  Future<void> updateCategory(Category category) {
    return productCategoryRoot
        .doc(category.id)
        .update(category.toEntity().toDocument());
  }

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
      Category category, Product product, bool available) {
    return productCategoryRoot
        .doc(category.id)
        .collection("products")
        .doc(product.id)
        .update({"available": available});
  }

  @override
  Future<ImageProvider> getProductImage(String productId) async {
    try {
      final url = await _getImageURL(productId + ".jpg");
      return NetworkImage(url);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setProductImage(Product product, Uint8List data) async {
    await _productImageBase.child(product.id + ".jpg").putData(Uint8List(20));
  }

  static Future<String> _getImageURL(String image) async {
    final path = _productImageBase.child(image);
    return await path.getDownloadURL();
  }
}
