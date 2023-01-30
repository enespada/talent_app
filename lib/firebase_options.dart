import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  //3B:94:B8:D5:A4:25:13:C4:2E:CC:79:34:CC:D8:96:28:0E:5D:72:04

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2eiGfaUiymuUYqFXVvNZMJwp8WHBTq4k',
    appId: '1:919987721348:android:713407d065e61e97131ed1',
    messagingSenderId: '919987721348',
    projectId: 'talentapp-dev-c0fad',
    storageBucket: 'talentapp-dev-c0fad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAF2WCHM5AjYtG5FeyCBycKcqfASdzIFp8',
    appId: '1:919987721348:ios:e236ac35a1a2d48b131ed1',
    messagingSenderId: '919987721348',
    projectId: 'talentapp-dev-c0fad',
    storageBucket: 'talentapp-dev-c0fad.appspot.com',
    iosClientId:
        '919987721348-o4adlptrfbcpdsft2vorcu1pmlc3964v.apps.googleusercontent.com',
    iosBundleId: 'com.talentapp.mobile.app',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
