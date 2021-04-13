import 'package:allocrepes/admin_notif/cubit/admin_notif_cubit.dart';
import 'package:allocrepes/admin_notif/cubit/admin_notif_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNotifView extends StatelessWidget {
  const AdminNotifView() : super();

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    final TextEditingController linkController = TextEditingController();
    final TextEditingController userController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        children: [
          TextField(
            onChanged: BlocProvider.of<AdminNotifCubit>(context).changeTitle,
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Titre',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            maxLines: 5,
            onChanged: BlocProvider.of<AdminNotifCubit>(context).changeBody,
            controller: bodyController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Action :"),
          BlocBuilder<AdminNotifCubit, AdminNotifState>(
            buildWhen: (prev, next) => prev.action != next.action,
            builder: (context, state) => Column(children: [
              ListTile(
                title: const Text("Envoyer sur la page principal"),
                leading: Radio<AdminNotifAction>(
                  value: AdminNotifAction.MainPage,
                  groupValue: state.action,
                  onChanged: (action) =>
                      BlocProvider.of<AdminNotifCubit>(context)
                          .changeAction(action ?? AdminNotifAction.MainPage),
                ),
              ),
              ListTile(
                title: const Text("Envoyer la page de commandes"),
                leading: Radio<AdminNotifAction>(
                  value: AdminNotifAction.OrderPage,
                  groupValue: state.action,
                  onChanged: (action) =>
                      BlocProvider.of<AdminNotifCubit>(context)
                          .changeAction(action ?? AdminNotifAction.MainPage),
                ),
              ),
              ListTile(
                title: const Text("Envoyer sur un lien"),
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
                    const Text("Lien : "),
                    TextField(
                      controller: linkController,
                      onChanged:
                          BlocProvider.of<AdminNotifCubit>(context).changeLink,
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Destinataire :"),
          BlocBuilder<AdminNotifCubit, AdminNotifState>(
            buildWhen: (prev, next) => prev.recipient != next.recipient,
            builder: (context, state) => Column(
              children: [
                ListTile(
                  title: const Text("Tout le monde"),
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
                  title: const Text("Les bougs sous Android"),
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
                  title: const Text("Les bougs sous iOS"),
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
                  title: const Text("Un boug en particulier"),
                  leading: Radio<AdminNotifRecipient>(
                    value: AdminNotifRecipient.User,
                    groupValue: state.recipient,
                    onChanged: (recipient) =>
                        BlocProvider.of<AdminNotifCubit>(context)
                            .changeRecipient(
                                recipient ?? AdminNotifRecipient.Everybody),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: state.recipient == AdminNotifRecipient.User,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Identifiant du boug : "),
                      TextField(
                        onChanged: BlocProvider.of<AdminNotifCubit>(context)
                            .changeUser,
                        controller: userController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
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
                const SizedBox(
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
                    child: const Text("Ok j'envoie"),
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
