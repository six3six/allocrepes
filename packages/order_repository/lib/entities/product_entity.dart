import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  ProductEntity(
    this.id,
    this.name,
    this.available,
    this.availableESIEE,
    this.maxAmount,
    this.initialStock,
    this.oneOrder,
  );

  final String? id;
  final String name;
  final bool available;
  final bool availableESIEE;
  final int maxAmount;
  final int initialStock;
  final bool oneOrder;

  @override
  List<Object?> get props => [
        id,
        name,
        available,
        availableESIEE,
        maxAmount,
        initialStock,
      ];

  @override
  String toString() =>
      'ProductEntity { id: $id, category: $name, available: $available, maxAmount: $maxAmount, initialStock: $initialStock }';

  static ProductEntity fromJson(Map<String, Object> json) => ProductEntity(
        json['id'] as String,
        json['name'] as String,
        json['available'] as bool,
        json['available_esiee'] as bool,
        json['maxAmount'] as int,
        json['initialStock'] as int,
        json['one_order'] as bool,
      );

  static ProductEntity fromSnapshot(DocumentSnapshot snapshot) => ProductEntity(
        snapshot.id,
        snapshot.get('name') as String,
        snapshot.get('available') as bool,
        snapshot.data()?['available_esiee'] ?? false,
        snapshot.data()?['maxAmount'] ?? 0,
        snapshot.data()?['initialStock'] ?? 0,
        snapshot.data()?['one_order'] ?? false,
      );

  Map<String, Object> toDocument() => {
        'name': name,
        'available': available,
        'available_esiee': availableESIEE,
        'maxAmount': maxAmount,
        'initialStock': initialStock,
        'one_order': oneOrder,
      };
}
