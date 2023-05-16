import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:setting_repository/setting_repository.dart';

class AdminUserCubit extends Cubit<AdminUserState> {
  AdminUserCubit(
    this._authenticationRepository,
    this._settingRepository,
  ) : super(const AdminUserState()) {
    getUser();
  }

  final AuthenticationRepository _authenticationRepository;
  final SettingRepository _settingRepository;
  Stream<Map<String, User>>? userStream;

  void getUser({
    String? username,
    SortUser? sortUser,
  }) {
    _settingRepository.showCls().listen((event) {
      emit(state.copyWith(showCls: event));
    });
  }

  void changeClsView(bool show) {
    _settingRepository.changeClsView(show);
  }

  void updateUser(User user) {
    _authenticationRepository.updateUser(user);
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
