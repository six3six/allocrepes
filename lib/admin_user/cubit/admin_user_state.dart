import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class AdminUserState extends Equatable {
  final bool isLoading;
  final bool showCls;
  final Map<String, User> users;
  final Map<String, bool> admin;

  final String usernameQuery;
  final SortUser sortUser;

  AdminUserState({
    this.isLoading = false,
    this.showCls = false,
    this.users = const {},
    this.admin = const {},
    this.usernameQuery = '',
    this.sortUser = SortUser.Name,
  });

  @override
  List<Object?> get props => [
        isLoading,
        showCls,
        usernameQuery,
        sortUser,
        ...users.keys,
        ...users.values,
        ...admin.keys,
        ...admin.values,
      ];

  @override
  String toString() {
    return 'AdminUserState(isLoading: $isLoading, showCls: $showCls, users: $users, admin: $admin, usernameQuery: $usernameQuery, sortUser: $sortUser)';
  }

  AdminUserState copyWith({
    bool? isLoading,
    bool? showCls,
    Map<String, User>? users,
    Map<String, bool>? admin,
    String? usernameQuery,
    SortUser? sortUser,
  }) {
    return AdminUserState(
      isLoading: isLoading ?? this.isLoading,
      showCls: showCls ?? this.showCls,
      users: users ?? this.users,
      admin: admin ?? this.admin,
      usernameQuery: usernameQuery ?? this.usernameQuery,
      sortUser: sortUser ?? this.sortUser,
    );
  }
}
