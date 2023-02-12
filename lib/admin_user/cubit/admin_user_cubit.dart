import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:setting_repository/setting_repository.dart';

class AdminUserCubit extends Cubit<AdminUserState> {
  AdminUserCubit(
    this._authenticationRepository,
    this._settingRepository,
  ) : super(AdminUserState()) {
    getUser();
  }

  final AuthenticationRepository _authenticationRepository;
  final SettingRepository _settingRepository;
  Stream<Map<String, User>>? userStream;

  void getUser({
    String? username,
    SortUser? sortUser,
  }) {
    userStream = _authenticationRepository.getUsers(
      username: username,
      sort: sortUser ?? SortUser.Name,
    );

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

    _settingRepository.showCls().listen((event) {
      emit(state.copyWith(showCls: event));
    });
  }

  void changeClsView(bool show) {
    _settingRepository.changeClsView(show);
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
    var adminL = <String, bool>{};
    adminL.addAll(state.admin);
    adminL[uid] = admin;
    emit(state.copyWith(
      admin: adminL,
    ));
  }

  void removeUser(String uid) {
    _authenticationRepository.removeUser(uid);
  }

  void updateUserQuery({
    String? username,
    SortUser? sortUser,
  }) {
    emit(state.copyWith(usernameQuery: username, sortUser: sortUser));
    getUser(
      username: username ?? state.usernameQuery,
      sortUser: sortUser ?? state.sortUser,
    );
  }
}
