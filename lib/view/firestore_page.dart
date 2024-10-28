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

  final TextEditingController _logController = TextEditingController(text: "");
  final ScrollController _logScrollController = ScrollController();

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
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  ButtonUtil.create(
                    onPressed: () async {
                      _addLog("初期化");
                      await _initData();
                    },
                    icon: Icons.format_color_reset,
                    label: "初期化",
                  ),

                  ButtonUtil.create(
                    onPressed: () async {
                      _addLog("データ表示");
                      await _viewData();
                    },
                    icon: Icons.view_day_sharp,
                    label: "データ表示",
                  ),

                  ButtonUtil.create(
                    onPressed: () async {
                      _addLog("追加(ID自動)");
                      await _addNewItem();
                    },
                    icon: Icons.create_new_folder,
                    label: "追加(ID自動)",
                  ),

                  ButtonUtil.create(
                    onPressed: () async {
                      _addLog("追加(ID指定)");
                      await _setNewItem();
                    },
                    icon: Icons.create_new_folder,
                    label: "追加(ID指定)",
                  ),

                ],
              )
            ),

            //　以下ログエリア
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
            )
          ],
        )
      ),
    );
  }

  ///　ログを追加
  void _addLog(String text){
    setState(() {
      _logController.text += "$text\n";
    });
    Logger.info(text);
  }

  /// エラーログを追加
  void _addErrorLog(String text, Object? e){
    setState(() {
      _logController.text += "$text\n";
    });
    Logger.error(text, exception: e);
  }

  /// データの書p帰化
  Future<void> _initData() async{
    _addLog("-- データを初期状態にする start ----------");

    try{
      _addLog("users コレクションを取得");
      // Userコレクションを取得
      CollectionReference users = FirebaseFirestore.instance.collection ('users');
      _addLog("取得したコレクションを確認");
      _addLog("User = ${users.id} / users.path = ${users.path}");

      // スナップショットからクエリを取得
      // 権限がないとここでpermissioのエラーになる
      _addLog("スナップショットからクエリを取得");
      var querySnapshot = await users.get();

      // ドキュメントを参照
      _addLog("ドキュメントを参照");
      _addLog("ドキュメント数 ${querySnapshot.docs.length}");

      // ドキュメントを削除する
      for (var doc in querySnapshot.docs) {
        _addLog("削除 ID : ${doc.id} / DATA : ${doc.data()}");
        await doc.reference.delete();
      }

      // 初期データを作成
      _addLog("初期データを作成");
      await users.doc("user1").set(
          {
            "name":"名前",
            "age":"45"
          }
      );

    }catch(e){
      _addErrorLog("", e);
    }
    _addLog("-- データを初期状態にする end ----------");
  }

  /// データを表示
  Future<void> _viewData() async{
    // Userコレクションを取得
    CollectionReference users = FirebaseFirestore.instance.collection ('users');
    _addLog("取得したコレクションを確認");
    _addLog("User = ${users.id} / users.path = ${users.path}");

    // スナップショットからクエリを取得
    // 権限がないとここでpermissioのエラーになる
    _addLog("スナップショットからクエリを取得");
    var querySnapshot = await users.get();

    // ドキュメントを参照
    _addLog("ドキュメントを参照");
    _addLog("ドキュメント数 ${querySnapshot.docs.length}");

    // ドキュメントを表示
    for (var doc in querySnapshot.docs) {
      _addLog("削除 ID : ${doc.id} / DATA : ${doc.data()}");
    }
  }

  /// 追加(add)
  Future<void> _addNewItem() async{
    CollectionReference users = FirebaseFirestore.instance.collection ('users');
    await users.add(
      {
        "name":"名前2",
        "age":"46"
      }
    );
  }

  /// 追加(set)
  Future<void> _setNewItem() async{
    CollectionReference users = FirebaseFirestore.instance.collection ('users');
    var querySnapshot = await users.get();
    await users.doc("user${querySnapshot.size}").set(
        {
          "name":"名前${querySnapshot.size}",
          "age":"${querySnapshot.size}"
        }
    );

  }
}