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
    this.photo,
  });

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  final bool admin;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String? photo;

  /// Empty user which represents an unauthenticated user.
  static const empty =
      User(email: '', id: '', admin: false, name: "", photo: null);

  User copyWith({
    String? email,
    String? id,
    bool? admin,
    String? name,
    String? photo,
  }) {
    return User(
      email: email ?? this.email,
      id: id ?? this.id,
      admin: admin ?? this.admin,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [email, id, admin, name, photo];
}
