import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PlaceEntity extends Equatable {
  final String name;
  final bool available;

  PlaceEntity({
    required this.name,
    required this.available,
  });

  @override
  List<Object> get props => [name, available];

  @override
  String toString() => 'PlaceEntity{name: $name, available: $available}';

  static fromSnapshot(DocumentSnapshot snapshot) => PlaceEntity(
        name: snapshot.id,
        available: snapshot.get('available') as bool,
      );

  Map<String, Object> toDocument() => {
        'available': available,
      };
}
