import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Firebase Realtime Databaseを利用するために以下を追加
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase_realtime_database_test/util/logger.dart';

import '../util/button_util.dart';


class FireStorePage extends StatefulWidget {

  const FireStorePage({super.key});
  @override
  State<FireStorePage> createState() => _FireStorePageState();
}

class _FireStorePageState extends State<FireStorePage> {

  @override
  void initState() {
    super.initState();

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(fontSize: 32);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("FireStore Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonUtil.create(
              onPressed: () async {
                _initData();
              },
              icon: Icons.format_color_reset,
              label: "初期化",
            ),
          ],
        ),
      ),
    );
  }

  /// データの書p帰化
  void _initData() async{
    Logger.info("-- データを初期状態にする start ----------");

    try{
      Logger.info("User コレクションを取得");
      // Userコレクションを取得
      CollectionReference users = FirebaseFirestore.instance.collection ('users');
      Logger.info("取得したコレクションを確認");
      Logger.info("User = ${users.id} / users.path = ${users.path}");

      // スナップショットからクエリを取得
      // 権限がないとここでpermissioのエラーになる
      Logger.info("スナップショットからクエリを取得");
      var querySnapshot = await users.get();

      // ドキュメントを参照
      Logger.info("ドキュメントを参照");
      for (var doc in querySnapshot.docs) {
        Logger.info("ID : ${doc.id}");
        Logger.info("DATA : ${doc.data()}");
      }

      // 今あるデータを削除する

      // 初期データを作成
    }catch(e){
      Logger.error("", exception: e);
    }
    Logger.info("-- データを初期状態にする end ----------");
  }


}