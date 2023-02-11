import 'package:allocrepes/admin_notif/cubit/admin_notif_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class AdminNotifCubit extends Cubit<AdminNotifState> {
  AdminNotifCubit() : super(AdminNotifState());

  final HttpsCallable funcSendNotif =
      FirebaseFunctions.instance.httpsCallable('sendNotif');

  void changeAction(AdminNotifAction action) {
    emit(state.copyWith(action: action));
  }

  void changeRecipient(AdminNotifRecipient recipient) {
    emit(state.copyWith(recipient: recipient));
  }

  void readyToSend() {
    emit(state.copyWith(readyToSend: true));
  }

  void changeLink(String link) {
    emit(state.copyWith(link: link));
  }

  void changeUser(String user) {
    emit(state.copyWith(userId: user));
  }

  void changeTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void changeBody(String body) {
    emit(state.copyWith(body: body));
  }

  Future<void> sendNotification(BuildContext context) async {
    emit(state.copyWith(isSending: true));
    try {
      await funcSendNotif({
        'title': state.title,
        'body': state.body,
        'action': state.action.index,
        'recipient': state.recipient.index,
        'link': state.link,
        'user': state.userId,
      });
      emit(state.copyWith(isSending: false));
      Navigator.pop(context);
    } on Exception catch (e, stacktrace) {
      emit(state.copyWith(isSending: false));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 30),
          content: Text(e.toString() + '\n' + stacktrace.toString()),
        ),
      );
    }
  }
}

enum AdminNotifAction {
  MainPage,
  OrderPage,
  LinkPage,
}

enum AdminNotifRecipient {
  Everybody,
  Android,
  Ios,
  User,
}
