import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/article_entity.dart';
import 'package:order_repository/entities/item_entity.dart';

import '../entities/order_entity.dart';
import '../entities/order_entity.dart';

class Item extends Equatable {
  const Item({
    @required this.id,
    @required this.name,
    @required this.category,
    @required this.available,
  })  : assert(id != null),
        assert(name != null),
        assert(category != null),
        assert(available != null);

  final String id;
  final String name;
  final String category;
  final bool available;

  static const empty = Item(id: "", name: "", category: "", available: false);

  @override
  List<Object> get props => [id, category, available];

  ItemEntity toEntity() {
    return ItemEntity(id, name, category, available);
  }

  static Item fromEntity(ItemEntity entity) {
    return Item(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      available: entity.available,
    );
  }
}
