import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class AdminUserState extends Equatable {
  final bool isLoading;
  final Map<String, User> users;

  AdminUserState({
    this.isLoading = false,
    this.users = const {},
  });

  @override
  List<Object?> get props => [
        isLoading,
        users,
      ];
}
