import 'package:allocrepes/admin_notif/cubit/admin_notif_cubit.dart';
import 'package:allocrepes/admin_notif/cubit/admin_notif_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNotifView extends StatelessWidget {
  const AdminNotifView() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        children: [
          Text("Titre :"),
          TextField(
            onChanged: BlocProvider.of<AdminNotifCubit>(context).changeTitle,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Description :"),
          TextField(
            maxLines: 5,
            onChanged: BlocProvider.of<AdminNotifCubit>(context).changeBody,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Action :"),
          BlocBuilder<AdminNotifCubit, AdminNotifState>(
            buildWhen: (prev, next) => prev.action != next.action,
            builder: (context, state) => Column(children: [
              ListTile(
                title: Text("Envoyer sur la page principal"),
                leading: Radio<AdminNotifAction>(
                  value: AdminNotifAction.MainPage,
                  groupValue: state.action,
                  onChanged: (action) =>
                      BlocProvider.of<AdminNotifCubit>(context)
                          .changeAction(action ?? AdminNotifAction.MainPage),
                ),
              ),
              ListTile(
                title: Text("Envoyer la page de commandes"),
                leading: Radio<AdminNotifAction>(
                  value: AdminNotifAction.OrderPage,
                  groupValue: state.action,
                  onChanged: (action) =>
                      BlocProvider.of<AdminNotifCubit>(context)
                          .changeAction(action ?? AdminNotifAction.MainPage),
                ),
              ),
              ListTile(
                title: Text("Envoyer sur un lien"),
                leading: Radio<AdminNotifAction>(
                  value: AdminNotifAction.LinkPage,
                  groupValue: state.action,
                  onChanged: (action) =>
                      BlocProvider.of<AdminNotifCubit>(context)
                          .changeAction(action ?? AdminNotifAction.MainPage),
                ),
              ),
              Visibility(
                visible: state.action == AdminNotifAction.LinkPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lien : "),
                    TextField(
                      onChanged:
                          BlocProvider.of<AdminNotifCubit>(context).changeLink,
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Destinataire :"),
          BlocBuilder<AdminNotifCubit, AdminNotifState>(
            buildWhen: (prev, next) => prev.recipient != next.recipient,
            builder: (context, state) => Column(
              children: [
                ListTile(
                  title: Text("Tout le monde"),
                  leading: Radio<AdminNotifRecipient>(
                    value: AdminNotifRecipient.Everybody,
                    groupValue: state.recipient,
                    onChanged: (recipient) =>
                        BlocProvider.of<AdminNotifCubit>(context)
                            .changeRecipient(
                                recipient ?? AdminNotifRecipient.Everybody),
                  ),
                ),
                ListTile(
                  title: Text("Les bougs sous Android"),
                  leading: Radio<AdminNotifRecipient>(
                    value: AdminNotifRecipient.Android,
                    groupValue: state.recipient,
                    onChanged: (recipient) =>
                        BlocProvider.of<AdminNotifCubit>(context)
                            .changeRecipient(
                                recipient ?? AdminNotifRecipient.Everybody),
                  ),
                ),
                ListTile(
                  title: Text("Les bougs sous iOS"),
                  leading: Radio<AdminNotifRecipient>(
                    value: AdminNotifRecipient.Ios,
                    groupValue: state.recipient,
                    onChanged: (recipient) =>
                        BlocProvider.of<AdminNotifCubit>(context)
                            .changeRecipient(
                                recipient ?? AdminNotifRecipient.Everybody),
                  ),
                ),
                ListTile(
                  title: Text("Un boug en particulier"),
                  leading: Radio<AdminNotifRecipient>(
                    value: AdminNotifRecipient.User,
                    groupValue: state.recipient,
                    onChanged: (recipient) =>
                        BlocProvider.of<AdminNotifCubit>(context)
                            .changeRecipient(
                                recipient ?? AdminNotifRecipient.Everybody),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: state.recipient == AdminNotifRecipient.User,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Identifiant du boug : "),
                      TextField(
                        onChanged: BlocProvider.of<AdminNotifCubit>(context)
                            .changeUser,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<AdminNotifCubit, AdminNotifState>(
            buildWhen: (prev, next) => prev.readyToSend != next.readyToSend,
            builder: (context, state) => Column(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: state.readyToSend
                        ? null
                        : () => BlocProvider.of<AdminNotifCubit>(context)
                            .readyToSend(),
                    child: Text("Je parle en sah"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: state.readyToSend
                        ? () => BlocProvider.of<AdminNotifCubit>(context)
                            .sendNotification(context)
                        : null,
                    child: Text("Ok j'envoie"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
