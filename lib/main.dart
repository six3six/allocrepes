import 'dart:async';
import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // Pass all uncaught errors to Crashlytics.
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError!(errorDetails);
    };

    var messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
        provisional: true,
      );
    } catch (exception, stack) {
      await FirebaseCrashlytics.instance.recordError(exception, stack);
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();

    print('Handling a background message: ${message.messageId}');
  }

  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print(e);
  }

  try {
    await FirebaseMessaging.instance.unsubscribeFromTopic('allusers');
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('androidusers');
    }
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.unsubscribeFromTopic('iosusers');
    }
  } catch (exception, stack) {
    await FirebaseCrashlytics.instance.recordError(exception, stack);
  }

  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = AppObserver();
  if (!kIsWeb) {
    runZonedGuarded(
      () => runApp(App(authenticationRepository: AuthenticationRepository())),
      (error, stackTrace) =>
          FirebaseCrashlytics.instance.recordError(error, stackTrace),
    );
  } else {
    runApp(App(authenticationRepository: AuthenticationRepository()));
  }
}
