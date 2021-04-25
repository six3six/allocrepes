import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase cubit, Change change) {
    print('${cubit.runtimeType} $change');
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.log('${cubit.runtimeType} $change');
    }
    super.onChange(cubit, change);
  }
}
