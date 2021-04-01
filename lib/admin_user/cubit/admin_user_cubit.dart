import 'package:allocrepes/admin_user/cubit/admin_user_state.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

class AdminUserCubit extends Cubit<AdminUserState> {
  AdminUserCubit(this._authenticationRepository) : super(AdminUserState()) {
    _authenticationRepository.getUsers().listen((event) {
      print(event);
    });
  }
  final AuthenticationRepository _authenticationRepository;
}
