import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderNewState extends Equatable {
  const OrderNewState({
    this.categories = const {},
    this.quantities = const {},
    this.alreadyOrdered = const [],
    this.place = Place.Ampere_A,
    this.room,
    this.placeError = '',
    this.loading = true,
    this.roomError = '',
    this.message = '',
  });

  final Map<Category, List<Product>> categories;
  final Map<String, int> quantities;
  final List<String> alreadyOrdered;
  final Place? place;
  final String? room;
  final String placeError;
  final String roomError;
  final bool loading;
  final String message;

  @override
  List<Object?> get props => [
        place,
        room,
        placeError,
        roomError,
        loading,
        message,
        ...categories.keys,
        ...categories.values,
        ...quantities.keys,
        ...quantities.values,
        ...alreadyOrdered,
      ];

  int getQuantity(Category category, Product product) {
    return quantities['${category.id};${product.id}'] ?? 0;
  }

  bool isAlreadyOrdered(Category category, Product product) {
    return alreadyOrdered.contains('${category.id};${product.id}') &&
        product.oneOrder;
  }

  OrderNewState copyWith({
    Map<Category, List<Product>>? categories,
    Map<String, int>? quantities,
    Place? place,
    String? room,
    String? placeError,
    String? roomError,
    bool? loading,
    String? message,
    List<String>? alreadyOrdered,
  }) {
    return OrderNewState(
      categories: categories ?? this.categories,
      quantities: quantities ?? this.quantities,
      place: place ?? this.place,
      room: room ?? this.room,
      placeError: placeError ?? this.placeError,
      roomError: roomError ?? this.roomError,
      loading: loading ?? this.loading,
      message: message ?? this.message,
      alreadyOrdered: alreadyOrdered ?? this.alreadyOrdered,
    );
  }
}
