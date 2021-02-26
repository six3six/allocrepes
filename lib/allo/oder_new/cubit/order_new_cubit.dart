import 'package:allocrepes/allo/order_list/view/order_list_page.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/article.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/order.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

import 'order_new_state.dart';

class OrderNewCubit extends Cubit<OrderNewState> {
  OrderNewCubit(this.orderRepository, this.user)
      : assert(orderRepository != null),
        super(const OrderNewState()) {
    getProducts();
  }

  final OrderRepository orderRepository;
  final User user;
  void getProducts() {
    orderRepository.categories().forEach((cats) {
      Map<Category, List<Product>> categories = {};

      cats.forEach((cat) {
        categories[cat] = [];
        orderRepository.productsFromCategory(cat).forEach((prods) {
          categories[cat] = prods;
          emit(state.copyWith(categories: categories));
        });
      });

      emit(state.copyWith(categories: categories));
    });
  }

  void updateQuantity(Category category, Product product, int quantity) {
    Map<String, int> q = {};
    q.addAll(state.quantities);
    q["${category.id};${product.id}"] = quantity;
    emit(state.copyWith(quantities: q));
  }

  int getQuantity(Category category, Product product) {
    return state.quantities["${category.id};${product.id}"] ?? 0;
  }

  void updateRoom(String room) {
    emit(state.copyWith(room: room));
    if (room == null || room == "") {
      emit(state.copyWith(roomError: "Pièce non définie"));
    } else {
      emit(state.copyWith(roomError: ""));
    }
  }

  void updatePlace(Place place) {
    emit(state.copyWith(place: place));
    if (place == null) {
      emit(state.copyWith(placeError: "Lieu non défini"));
    } else {
      emit(state.copyWith(placeError: ""));
    }
  }

  bool checkout() {
    updateRoom(state.room);
    updatePlace(state.place);
    if (state.roomError != "" || state.placeError != "") return false;

    List<Article> articles = [];
    state.categories.forEach((category, products) => products.forEach(
        (product) => articles.add(Article(
            product: product, amount: getQuantity(category, product)))));

    orderRepository.createOrder(Order(
      status: OrderStatus.UNKNOWN,
      userId: user.id,
      createdAt: DateTime.now(),
      articles: articles,
      place: state.place.name,
      room: state.room,
    ));
    return true;
  }
}
