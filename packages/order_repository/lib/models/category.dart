import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/entities/category_entity.dart';

class Category extends Equatable {
  const Category({
    this.id,
    required this.name,
  });

  final String? id;
  final String name;

  static const empty = Category(id: "", name: "");

  @override
  List<Object?> get props => [id, name];

  Category copyWith({String? name}) {
    return Category(
      id: id,
      name: name ?? this.name,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id, name);
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
    );
  }
}
