import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class AdminUserState extends Equatable {
  final bool isLoading;
  final Map<String, User> users;
  final Map<String, bool> admin;

  final String usernameQuery;
  final SortUser sortUser;

  AdminUserState({
    this.isLoading = false,
    this.users = const {},
    this.admin = const {},
    this.usernameQuery = "",
    this.sortUser = SortUser.Name,
  });

  @override
  List<Object?> get props => [
        isLoading,
        usernameQuery,
        sortUser,
      ]
        ..addAll(users.keys)
        ..addAll(users.values)
        ..addAll(admin.keys)
        ..addAll(admin.values);

  @override
  String toString() {
    return "AdminUserState(isLoading: $isLoading, users: $users, admin: $admin, usernameQuery: $usernameQuery, sortUser: $sortUser)";
  }

  AdminUserState copyWith({
    bool? isLoading,
    Map<String, User>? users,
    Map<String, bool>? admin,
    String? usernameQuery,
    SortUser? sortUser,
  }) {
    return AdminUserState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      admin: admin ?? this.admin,
      usernameQuery: usernameQuery ?? this.usernameQuery,
      sortUser: sortUser ?? this.sortUser,
    );
  }
}
