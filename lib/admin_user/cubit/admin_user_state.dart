import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class AdminUserState extends Equatable {
  final bool isLoading;
  final bool showCls;

  final String usernameQuery;
  final SortUser sortUser;

  AdminUserState({
    this.isLoading = false,
    this.showCls = false,
    this.usernameQuery = '',
    this.sortUser = SortUser.Name,
  });

  @override
  List<Object?> get props => [
        isLoading,
        showCls,
        usernameQuery,
        sortUser,
      ];

  @override
  String toString() {
    return 'AdminUserState(isLoading: $isLoading, showCls: $showCls, usernameQuery: $usernameQuery, sortUser: $sortUser)';
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
      usernameQuery: usernameQuery ?? this.usernameQuery,
      sortUser: sortUser ?? this.sortUser,
    );
  }
}
