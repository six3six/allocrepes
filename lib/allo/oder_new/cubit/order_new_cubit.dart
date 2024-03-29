import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

import 'order_new_state.dart';

class OrderNewCubit extends Cubit<OrderNewState> {
  OrderNewCubit(
    this.orderRepository,
    this.authenticationRepository,
    this.user,
  ) : super(const OrderNewState()) {
    getProducts();
  }

  final OrderRepository orderRepository;
  final AuthenticationRepository authenticationRepository;
  final User user;

  void getProducts() {
    orderRepository.categories().forEach((cats) {
      var categories = <Category, List<Product>>{};

      for (var cat in cats) {
        categories[cat] = [];
        emit(state.copyWith(categories: categories));

        orderRepository.productsFromCategory(cat).forEach((prods) {
          var categories = <Category, List<Product>>{}
            ..addAll(state.categories);
          categories[cat] = prods;
          emit(state.copyWith(categories: categories));
        });
      }

      emit(state.copyWith(
        categories: categories,
        loading: false,
      ));
    });

    orderRepository.userOrders(orderStatus: <OrderStatus>[
      OrderStatus.DELIVERED,
      OrderStatus.DELIVERING,
      OrderStatus.PENDING,
      OrderStatus.VALIDATING,
    ]).forEach((orders) {
      var alreadyOrdered = <String>[];
      for (var order in orders) {
        for (var article in order.articles) {
          alreadyOrdered.add('${article.categoryId};${article.productId}');
        }
      }

      emit(state.copyWith(alreadyOrdered: alreadyOrdered));
    });
  }

  List<Product> getAvailableProduct(Category cat) =>
      state.categories[cat]?.where((product) => product.available).toList() ??
      [];

  List<Product> getAvailableESIEEProduct(Category cat) =>
      state.categories[cat]
          ?.where((product) => product.availableESIEE)
          .toList() ??
      [];

  Map<Category, List<Product>> getAvailableCategories() => state.categories
      .map((key, value) => MapEntry(key, getAvailableProduct(key)));

  Map<Category, List<Product>> getAvailableESIEECategories() => state.categories
      .map((key, value) => MapEntry(key, getAvailableESIEEProduct(key)));

  void updateQuantity(Category category, Product product, int quantity) {
    var q = <String, int>{};
    q.addAll(state.quantities);
    q['${category.id};${product.id}'] = quantity;
    emit(state.copyWith(quantities: q));
  }

  int getQuantity(Category category, Product product) =>
      state.getQuantity(category, product);

  void updateRoom(String? room) {
    emit(state.copyWith(room: room));
    if ((room == null || room == '')) {
      emit(state.copyWith(roomError: 'Salle non définie'));
    } else {
      emit(state.copyWith(roomError: ''));
    }
  }

  void updatePhone(String? phone) {
    emit(state.copyWith(room: phone));
    if ((phone == null || phone == '')) {
      emit(state.copyWith(phone: 'Téléphone non définie'));
    } else {
      emit(state.copyWith(phone: ''));
    }
  }

  void updatePlace(Place? place) {
    emit(state.copyWith(place: place));
    if (place == null) {
      emit(state.copyWith(placeError: 'Lieu non défini'));
    } else {
      emit(state.copyWith(placeError: ''));
    }
  }

  void updateMessage(String message) {
    emit(state.copyWith(message: message));
  }

  bool checkAvailability(Product product) =>
      ((state.place != Place.ESIEE && product.available) ||
          (state.place == Place.ESIEE && product.availableESIEE));

  Future<bool> checkout(BuildContext context) async {
    updateRoom(state.room);
    updatePlace(state.place);
    updatePhone(state.phone);

    if (state.roomError != '' ||
        state.placeError != '' ||
        state.phoneError != '') {
      await showError(
          context, 'Remplissez le lieu, la salle et votre numéro de téléphone');

      return false;
    }

    var articles = <Article>[];
    state.categories
        .forEach((category, products) => products.forEach((product) {
              final q = getQuantity(category, product);
              if (q > 0 && checkAvailability(product)) {
                articles.add(Article(
                  productId: product.id ?? '',
                  categoryId: category.id ?? '',
                  amount: q,
                ));
              }
            }));

    if (articles.isEmpty) {
      await showError(context, 'Choisissez au moins un article');

      return false;
    }

    try {
      emit(state.copyWith(loading: true));
      if (state.place == null) {
        throw Exception('Il manque le batiment');
      }
      if (state.room == null) {
        throw Exception('Il manque la piece');
      }
      if (state.phone == null) {
        throw Exception('Il manque un numéro de téléphone');
      }

      authenticationRepository.updateUser(user.copyWith(phone: state.phone));
      await orderRepository.createOrder(Order(
        status: OrderStatus.VALIDATING,
        owner: user.id,
        createdAt: DateTime.now(),
        articles: articles,
        place: state.place ?? Place.UNKNOWN,
        room: state.room ?? '',
        message: state.message,
        phone: state.phone ?? '',
      ));

      return true;
    } catch (e, stacktrace) {
      await showError(
        context,
        'Erreur du système : ${e.toString()}\n\n${stacktrace.toString()}',
      );
      if (foundation.kDebugMode) {
        print('Checkout error $e');
      }
      if (foundation.kDebugMode) {
        print('Checkout stacktrace $stacktrace');
      }
      emit(state.copyWith(loading: false));

      return false;
    }
  }

  Future<void> showError(BuildContext context, String message) =>
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Erreur'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      );
}
