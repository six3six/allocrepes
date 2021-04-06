import 'package:equatable/equatable.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderNewState extends Equatable {
  const OrderNewState({
    this.categories = const {},
    this.quantities = const {},
    this.place = Place.Ampere_A,
    this.room,
    this.placeError = "",
    this.loading = false,
    this.roomError = "",
    this.message = "",
  });

  final Map<Category, List<Product>> categories;
  final Map<String, int> quantities;
  final Place? place;
  final String? room;
  final String placeError;
  final String roomError;
  final bool loading;
  final String message;

  @override
  List<Object?> get props => [
        categories.values,
        categories.entries.toList(),
        quantities.values,
        quantities.entries.toList(),
        place,
        room,
        placeError,
        roomError,
        loading,
        message,
      ];

  OrderNewState copyWith({
    Map<Category, List<Product>>? categories,
    Map<String, int>? quantities,
    Place? place,
    String? room,
    String? placeError,
    String? roomError,
    bool? loading,
    String? message,
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
    );
  }
}
