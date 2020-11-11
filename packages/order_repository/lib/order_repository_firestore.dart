import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_repository/entities/article_entity.dart';
import 'package:order_repository/entities/order_entity.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/order_repository.dart';

import 'entities/item_entity.dart';
import 'models/article.dart';
import 'models/item.dart';
import 'models/order_status.dart';

class OrderRepositoryFirestore extends OrderRepository {
  final CollectionReference orderRoot =
      FirebaseFirestore.instance.collection("orders");

  final CollectionReference itemRoot =
      FirebaseFirestore.instance.collection("items");

  List<Item> itemsList = [];

  OrderRepositoryFirestore() {
    items().listen((List<Item> items) => itemsList = items);
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
  void cancelOrder(Order order) {
    orderRoot.doc(order.id).update({"status": OrderStatus.CANCELED.index});
  }

  @override
  Stream<Order> order(String id) async* {
    await for (DocumentSnapshot doc in orderRoot.doc("id").snapshots()) {
      yield await _orderFromEntity(OrderEntity.fromSnapshot(doc));
    }
  }

  @override
  Stream<List<Item>> items() {
    return itemRoot.snapshots().map<List<Item>>((QuerySnapshot snapshot) =>
        snapshot.docs.map<Item>((QueryDocumentSnapshot doc) =>
            Item.fromEntity(ItemEntity.fromSnapshot(doc))));
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

  Item _itemById(String id) {
    for (Item item in itemsList) {
      if (item.id == id) return item;
    }
    return null;
  }
}
