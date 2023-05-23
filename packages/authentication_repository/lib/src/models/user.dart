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
    required this.student,
    required this.phone,
    this.photo,
  });

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  final bool admin;

  final bool student;

  /// The current user's name (display name).
  final String name;
  final String surname;

  final String classe;
  final String phone;

  /// Url for the current user's photo.
  final String? photo;

  final int point;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(
    email: '',
    id: '',
    admin: false,
    name: '',
    surname: '',
    classe: '',
    point: 0,
    photo: null,
    phone: '',
    student: false,
  );

  User copyWith({
    String? email,
    String? id,
    bool? admin,
    String? name,
    String? surname,
    String? classe,
    String? photo,
    String? phone,
    int? point,
    bool? student,
  }) =>
      User(
        email: email ?? this.email,
        id: id ?? this.id,
        admin: admin ?? this.admin,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        classe: classe ?? this.classe,
        photo: photo ?? this.photo,
        point: point ?? this.point,
        phone: phone ?? this.phone,
        student: student ?? this.student,
      );

  Map<String, Object?> toDocument() {
    return {
      'surname': surname,
      'admin': admin,
      'name': name,
      'email': email,
      'point': point,
      'classe': classe,
    };
  }

  // TODO Refactor the "snapshot to data" system
  static User fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>? ?? {};

    return User(
      email: data['email'] ?? '',
      id: document.id,
      admin: data['admin'] ?? false,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      classe: data['classe'] ?? '',
      phone: data['phone'] ?? '',
      point: data['point'] ?? 0,
      student: data.containsKey('name') ? true : false,
    );
  }

  bool isNotEmpty() {
    return id != '';
  }

  @override
  List<Object?> get props => [
        email,
        id,
        admin,
        name,
        photo,
        point,
        surname,
        student,
      ];
}
