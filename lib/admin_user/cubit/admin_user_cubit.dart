import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

class AdminUserCubit extends Cubit<AdminUserState> {
  AdminUserCubit(this._authenticationRepository) : super(AdminUserState()) {
    getUser();
  }

  final AuthenticationRepository _authenticationRepository;
  Stream<Map<String, User>>? userStream;

  void getUser({
    String? username,
  }) {
    userStream = _authenticationRepository.getUsers(username: username);

    userStream?.listen((users) {
      emit(
        state.copyWith(
          users: users,
          admin: users.map(
            (key, value) => MapEntry(key, value.admin),
          ),
        ),
      );
    });
  }

  void userUpdate(User user) {
    _authenticationRepository.updateUser(user);
  }

  void setUserInfo(
    String uid,
    String surname,
    String name,
    String email,
    int point,
  ) {
    _authenticationRepository.setUserInfo(uid, surname, name, email, point);
  }

  void setUserAdmin(String uid, bool admin) {
    _authenticationRepository.setUserAdmin(uid, admin);
  }

  void changeRole(String uid, bool admin) {
    Map<String, bool> adminL = {};
    adminL.addAll(state.admin);
    adminL[uid] = admin;
    emit(state.copyWith(
      admin: adminL,
    ));
  }

  void updateUserQuery(String username){
    emit(state.copyWith(usernameQuery: username));
    getUser(username: username);
  }
}
