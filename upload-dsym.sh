find build/ios/archive/Runner.xcarchive/dSYMs -name "*.dSYM" | xargs -I \{\} ios/Pods/FirebaseCrashlytics/upload-symbols -gsp ios/Runner/GoogleService-Info.plist -p ios \{\}