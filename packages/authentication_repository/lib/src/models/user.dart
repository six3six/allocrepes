import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    @required this.email,
    @required this.id,
    @required this.admin,
    @required this.name,
    @required this.photo,
  })  : assert(email != null),
        assert(admin != null),
        assert(name != null),
        assert(id != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  final bool admin;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String photo;

  /// Empty user which represents an unauthenticated user.
  static const empty =
      User(email: '', id: '', admin: false, name: "", photo: null);

  @override
  List<Object> get props => [email, id, admin, name, photo];
}
