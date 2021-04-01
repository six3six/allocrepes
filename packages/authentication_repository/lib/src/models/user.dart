import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.email,
    required this.id,
    required this.admin,
    required this.name,
    required this.surname,
    required this.classe,
    required this.point,
    this.photo,
  });

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  final bool admin;

  /// The current user's name (display name).
  final String name;
  final String surname;

  final String classe;

  /// Url for the current user's photo.
  final String? photo;

  final int point;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(
    email: '',
    id: '',
    admin: false,
    name: "",
    surname: "",
    classe: "",
    point: 0,
    photo: null,
  );

  User copyWith(
      {String? email,
      String? id,
      bool? admin,
      String? name,
      String? surname,
      String? classe,
      String? photo,
      int? point}) {
    return User(
      email: email ?? this.email,
      id: id ?? this.id,
      admin: admin ?? this.admin,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      classe: classe ?? this.classe,
      photo: photo ?? this.photo,
      point: point ?? this.point,
    );
  }

  static User fromDocument(QueryDocumentSnapshot document) {
    var data = document.data() ?? {};
    return User(
      email: data.containsKey("email") ? data["email"] : "",
      id: document.id,
      admin: false,
      name: data.containsKey("name") ? data["name"] : "",
      surname: data.containsKey("surname") ? data["surname"] : "",
      classe: data.containsKey("classe") ? data["classe"] : "",
      point: data.containsKey("point") ? data["point"] : 0,
    );
  }

  @override
  List<Object?> get props => [email, id, admin, name, photo];
}
