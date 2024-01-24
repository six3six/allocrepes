import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    if (kDebugMode) {
      print('${bloc.runtimeType} $change');
    }
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log('${bloc.runtimeType} $change');
    }
    super.onChange(bloc, change);
  }
}
