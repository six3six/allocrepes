import 'package:allocrepes/admin_notif/cubit/admin_notif_cubit.dart';
import 'package:allocrepes/admin_notif/cubit/admin_notif_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNotifView extends StatelessWidget {
  const AdminNotifView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          children: [
            _CommonBlock(),
            const SizedBox(
              height: 20,
            ),
            _ActionBlock(),
            const SizedBox(
              height: 20,
            ),
            _RecipientBlock(),
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
                      child: const Text('Je parle en sah'),
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

class _CommonBlock extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

class _ActionBlock extends StatelessWidget {
  final TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Action :'),
        BlocBuilder<AdminNotifCubit, AdminNotifState>(
          buildWhen: (prev, next) => prev.action != next.action,
          builder: (context, state) => Column(children: [
            const _ActionCheckBox(
              text: 'Envoyer sur la page principal',
              action: AdminNotifAction.MainPage,
            ),
            const _ActionCheckBox(
              text: 'Envoyer la page de commandes',
              action: AdminNotifAction.OrderPage,
            ),
            const _ActionCheckBox(
              text: 'Envoyer sur un lien',
              action: AdminNotifAction.LinkPage,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AdminNotifCubit, AdminNotifState>(
              buildWhen: (prev, next) => prev.action != next.action,
              builder: (context, state) => Visibility(
                visible: state.action == AdminNotifAction.LinkPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lien : '),
                    TextField(
                      controller: linkController,
                      onChanged:
                          BlocProvider.of<AdminNotifCubit>(context).changeLink,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _ActionCheckBox extends StatelessWidget {
  final String text;
  final AdminNotifAction action;

  const _ActionCheckBox({
    Key? key,
    required this.text,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
      ),
      leading: BlocBuilder<AdminNotifCubit, AdminNotifState>(
        buildWhen: (prev, next) => prev.action != next.action,
        builder: (context, state) => Radio<AdminNotifAction>(
          value: action,
          groupValue: state.action,
          onChanged: (action) =>
              BlocProvider.of<AdminNotifCubit>(context).changeAction(
            action ?? AdminNotifAction.MainPage,
          ),
        ),
      ),
    );
  }
}

class _RecipientBlock extends StatelessWidget {
  final TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Destinataire :'),
        const _RecipientCheckBox(
          text: 'Tout le monde',
          recipient: AdminNotifRecipient.Everybody,
        ),
        const _RecipientCheckBox(
          text: 'Les bougs sous Android',
          recipient: AdminNotifRecipient.Android,
        ),
        const _RecipientCheckBox(
          text: 'Les bougs sous iOS',
          recipient: AdminNotifRecipient.Ios,
        ),
        const _RecipientCheckBox(
          text: 'Un boug en particulier',
          recipient: AdminNotifRecipient.User,
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<AdminNotifCubit, AdminNotifState>(
          buildWhen: (prev, next) => prev.recipient != next.recipient,
          builder: (context, state) => Visibility(
            visible: state.recipient == AdminNotifRecipient.User,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Identifiant du boug : '),
                TextField(
                  onChanged:
                      BlocProvider.of<AdminNotifCubit>(context).changeUser,
                  controller: userController,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipientCheckBox extends StatelessWidget {
  final String text;
  final AdminNotifRecipient recipient;

  const _RecipientCheckBox({
    Key? key,
    required this.text,
    required this.recipient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
      ),
      leading: BlocBuilder<AdminNotifCubit, AdminNotifState>(
        buildWhen: (prev, next) => prev.recipient != next.recipient,
        builder: (context, state) => Radio<AdminNotifRecipient>(
          value: recipient,
          groupValue: state.recipient,
          onChanged: (recipient) =>
              BlocProvider.of<AdminNotifCubit>(context).changeRecipient(
            recipient ?? AdminNotifRecipient.Everybody,
          ),
        ),
      ),
    );
  }
}
