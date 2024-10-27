import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

// Firebase Realtime Databaseを利用するために以下を追加
import 'package:flutter_firebase_realtime_database_test/util/logger.dart';
import 'package:flutter_firebase_realtime_database_test/view/firestore_page.dart';
import 'package:flutter_firebase_realtime_database_test/view/realtime_database_page.dart';
import 'package:google_sign_in/google_sign_in.dart';


class MainPage extends StatefulWidget {

  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(fontSize: 32);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Firebase Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              onPressed: () async {
                _callGoogleSignIn();
              },
              icon: const Icon(Icons.login, size: 32,),
              label: Text("ログイン", style: textStyle),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RealtimeDatabasePage(),)
                );
              },
              icon: const Icon(Icons.next_plan, size: 32,),
              label: Text("RealtimeDatabase", style: textStyle),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FireStorePage(),)
                );
              },
              icon: const Icon(Icons.next_plan, size: 32,),
              label: Text("FireStore", style: textStyle),
            ),
          ],
        ),
      ),
    );
  }

  void _callGoogleSignIn() async{
    try{
      Logger.info("Googleへのサインイン");
      // Googleサインインをトリガー
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Logger.warn("Googleログインキャンセルされました");
        return;
      }

      Logger.info("Google認証情報を取得");
      // Google認証情報を取得
      var googleAuth = await googleUser.authentication;

      Logger.info("Firebaseへのサインイン");
      // FirebaseにGoogleの認証情報でサインイン
      var credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var userCredential = await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
      Logger.info("ログイン成功: ${userCredential.user?.displayName}");
      // ログイン成功後の画面遷移などを実行
    }catch(e){
      Logger.error("ログインエラー", exception: e);
    }
  }
}