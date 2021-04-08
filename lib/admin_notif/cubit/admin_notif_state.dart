import 'package:allocrepes/admin_notif/cubit/admin_notif_cubit.dart';
import 'package:equatable/equatable.dart';

class AdminNotifState extends Equatable {
  final AdminNotifAction action;
  final AdminNotifRecipient recipient;
  final bool readyToSend;
  final String userId;
  final String link;
  final String title;
  final String body;
  final bool isSending;

  AdminNotifState({
    this.action = AdminNotifAction.MainPage,
    this.recipient = AdminNotifRecipient.Everybody,
    this.readyToSend = false,
    this.userId = "",
    this.link = "",
    this.title = "",
    this.body = "",
    this.isSending = false,
  });

  @override
  List<Object?> get props => [
        action,
        recipient,
        readyToSend,
        userId,
        link,
        title,
        body,
        isSending,
      ];

  AdminNotifState copyWith({
    AdminNotifAction? action,
    AdminNotifRecipient? recipient,
    bool readyToSend = false,
    String? userId,
    String? link,
    String? title,
    String? body,
    bool? isSending,
  }) {
    return AdminNotifState(
      action: action ?? this.action,
      recipient: recipient ?? this.recipient,
      readyToSend: readyToSend,
      userId: userId ?? this.userId,
      link: link ?? this.link,
      title: title ?? this.title,
      body: body ?? this.body,
      isSending: isSending ?? this.isSending,
    );
  }
}
