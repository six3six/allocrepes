import 'dart:io';

import 'package:allocrepes/splash/splash.dart';
import 'package:allocrepes/theme.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'lobby/view/lobby_page.dart';
import 'login/view/login_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);
  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: RepositoryProvider(
          create: (BuildContext context) => OrderRepositoryFirestore(),
          child: AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  Future<void> getNotif(RemoteMessage? initialMessage) async {
    if (initialMessage == null) return;
    if (initialMessage.data.containsKey('link')) {
      await canLaunch(initialMessage.data['link'])
          ? await launch(initialMessage.data['link'])
          : throw 'Could not launch ${initialMessage.data["link"]}';

      return;
    }

    if (initialMessage.data.containsKey('type')) {
      switch (initialMessage.data['type'] as String) {
        default:
          return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((initialMessage) => getNotif(initialMessage));
    FirebaseMessaging.onMessageOpenedApp.listen((initialMessage) {
      getNotif(initialMessage);
    });
  }

  String prevUserId = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xanthos',
      theme: theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (prev, next) =>
              prev.status != next.status ||
              prev.user.id != next.user.id ||
              prev.user.student != next.user.student,
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                print('authenticated');
                if (!kIsWeb) {
                  try {
                    if (state.user.student) {
                      FirebaseMessaging.instance.subscribeToTopic('allusers');
                      if (Platform.isAndroid) {
                        FirebaseMessaging.instance
                            .subscribeToTopic('androidusers');
                      }
                      if (Platform.isIOS) {
                        FirebaseMessaging.instance.subscribeToTopic('iosusers');
                      }
                    }

                    print('subscribeToTopic(user${state.user.id})');
                    FirebaseMessaging.instance
                        .subscribeToTopic('user${state.user.id}');
                  } catch (exception, stack) {
                    FirebaseCrashlytics.instance.recordError(exception, stack);
                  }

                  // App Tracking Transparency
                  try {
                    AppTrackingTransparency.requestTrackingAuthorization()
                        .then((status) {
                      switch (status) {
                        case TrackingStatus.notDetermined:
                        case TrackingStatus.restricted:
                        case TrackingStatus.denied:
                          break;
                        case TrackingStatus.authorized:
                        case TrackingStatus.notSupported:
                          FirebaseCrashlytics.instance
                              .setUserIdentifier(state.user.id);
                          break;
                      }
                    });
                    // If the system can show an authorization request dialog
                  } catch (e, stack) {
                    FirebaseCrashlytics.instance.recordError(e, stack);
                  }
                }
                prevUserId = state.user.id;

                _navigator.pushAndRemoveUntil<void>(
                  LobbyPage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                if (!kIsWeb) {
                  try {
                    FirebaseMessaging.instance
                        .unsubscribeFromTopic('user$prevUserId');
                    FirebaseMessaging.instance.unsubscribeFromTopic('allusers');
                    if (Platform.isAndroid) {
                      FirebaseMessaging.instance
                          .unsubscribeFromTopic('androidusers');
                    }
                    if (Platform.isIOS) {
                      FirebaseMessaging.instance
                          .unsubscribeFromTopic('iosusers');
                    }
                  } catch (exception, stack) {
                    FirebaseCrashlytics.instance.recordError(exception, stack);
                  }
                }
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
