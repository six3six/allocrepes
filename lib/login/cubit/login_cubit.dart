import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void showLoginForm() {
    emit(state.copyWith(showLoginForm: true));
  }

  Future<void> login(String url) async {
    final response = await http.get(Uri.parse(url));
    final decodedData = jsonDecode(response.body);

    await _authenticationRepository.logInWithToken(token: decodedData['token']);
  }

  Future<void> loginWithToken(String token) async {
    await _authenticationRepository.logInWithToken(token: token);
  }
}
