import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _logController = TextEditingController(text: "");
  final ScrollController _logScrollController = ScrollController();

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
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      _login();
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
            Expanded(
              flex: 5,
              child: Scrollbar(
                trackVisibility: true,
                thumbVisibility: true,
                interactive: true,
                thickness: 10.0,
                controller: _logScrollController,
                child:SingleChildScrollView(
                  controller: _logScrollController,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _logController,
                    readOnly: true,
                    onChanged: (value) {
                    },
                  )
                )
              )
            ),
          ],
        )
      )
    );
  }

  void _addLog(String text){
    setState(() {
      _logController.text += "$text\n";
    });
    Logger.info(text);
  }

  void _addErrorLog(String text, Object? e){
    setState(() {
      _logController.text += "$text\n";
    });
    Logger.error(text, exception: e);
  }

  /// GoogleサインインとFirebase認証
  void _login() async{
    _addLog("ログイン開始");

    GoogleSignInAuthentication? googleAuth;
    try{
      googleAuth = await _googleAuth();
    }catch(e){
      _addErrorLog("ログインエラー", e);
    }

    if(googleAuth == null){
      _addLog("Googleログインキャンセルされました");
    }

    _addLog("Firebase認証");
    try{
      _firebaseAuth(googleAuth!);
    }catch(e){
      _addErrorLog("ログインエラー", e);
    }
    _addLog("ログイン完了");
  }

  /// Googl認証
  Future<GoogleSignInAuthentication?> _googleAuth() async{
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    _addLog("Google認証情報を取得");
    // Google認証情報を取得
    return await googleUser.authentication;
  }

  /// Firebase認証
  Future<UserCredential?> _firebaseAuth(GoogleSignInAuthentication auth) async{
    var credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

}