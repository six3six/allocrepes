import 'package:flutter/material.dart';

class LoginESIPEDialog extends StatelessWidget {
  final emailFieldController = TextEditingController();

  LoginESIPEDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(title: Text('Connexion ex-ESIPE'),),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 75),
                Text(
                  'Entrez votre mail ESIPE (@univ-eiffel.fr)',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailFieldController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Valider'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
