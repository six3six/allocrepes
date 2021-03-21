import 'package:equatable/equatable.dart';
import 'package:order_repository/entities/place_entity.dart';

class Place extends Equatable {
  final String name;
  final bool available;

  const Place({
    required this.name,
    this.available = false,
  });

  static const empty = Place(name: "");

  @override
  List<Object> get props => [name, available];

  static Place fromEntity(PlaceEntity entity) {
    return Place(
      name: entity.name,
      available: entity.available,
    );
  }
}
