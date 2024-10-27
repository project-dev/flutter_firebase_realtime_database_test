# 参考


## Rwaltime Database
この辺を見ておけばわかる

- [Realtime Database の制限事項](https://firebase.google.com/docs/database/usage/limits?hl=ja)
- [Flutter アプリに Firebase を追加する](https://firebase.google.com/docs/flutter/setup?hl=ja&platform=android)
- [Realtime Database を使ってみる](https://firebase.google.com/docs/database/flutter/start?hl=ja&_gl=1*26vfj1*_up*MQ..*_ga*MTcwMTgxOTMyMy4xNzExMTk2OTQ3*_ga_CW55HF8NVT*MTcxMTE5Njk0Ny4xLjAuMTcxMTE5Njk0Ny4wLjAuMA..)

## Firestore




# その他

## FirebaseAuth.instance.signInWithCredential(credential)でype 'List<Object?>' is not a subtype of type 'PigeonUserDetails?' in type castが発生する

[公式の対応](https://github.com/firebase/flutterfire/issues/13077)はダメだった
pubspec.ymlに記載されているFirebase関連のバージョンを変更し、flutter pub getしたら解決した。
