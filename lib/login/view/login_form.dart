import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'login_widgets.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: <Widget>[
            kIsWeb
                ? AuthTokenView()
                : Expanded(
                    child: AuthWebView(),
                  ),
            const SizedBox(height: 20.0),
          ],
        ),
      );
}
