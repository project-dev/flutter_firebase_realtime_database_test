import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_firebase_realtime_database_test/util/logger.dart';

import '../Model/person_model.dart';
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
                  Row(
                    children: [
                      ButtonUtil.create(
                        onPressed: () async {
                          _addLog("初期化");
                          await _initData();
                        },
                        icon: Icons.format_color_reset,
                        label: "初期化",
                      ),
                    ],
                  ),
                  Row(
                    children: [
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
                  ),
                  Row(
                    children: [
                      ButtonUtil.create(
                        onPressed: () async {
                          _addLog("更新");
                          await _updateItem();
                        },
                        icon: Icons.create_new_folder,
                        label: "更新",
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ButtonUtil.create(
                        onPressed: () async {
                          _addLog("全データ表示");
                          await _viewData();
                        },
                        icon: Icons.view_day_sharp,
                        label: "全データ表示",
                      ),
                      ButtonUtil.create(
                        onPressed: () async {
                          _addLog("全データ表示(model)");
                          await _getDataModel();
                        },
                        icon: Icons.view_day_sharp,
                        label: "全データ表示(model)",
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ButtonUtil.create(
                        onPressed: () async {
                          _addLog("単体データ取得");
                          await _getData();
                        },
                        icon: Icons.file_upload,
                        label: "単体データ取得",
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ButtonUtil.create(
                        onPressed: () async {
                          _addLog("単体データ削除");
                          await _deleteData();
                        },
                        icon: Icons.delete,
                        label: "単体データ削除",
                      ),
                    ],
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

      FirebaseFirestore.instance.collection('users2').add({
        'name':'aaaaa',
        'age':24
      });

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
      _addLog("ID : ${doc.id} / DATA : ${doc.data()}");
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

  /// 更新
  Future<void> _updateItem() async{
    CollectionReference users = FirebaseFirestore.instance.collection ('users');
    await users.doc("user1").set(
        {
          "name":"名前更新",
          "age":"100"
        }
    );
  }

  /// 取得(モデル)
  Future<void> _getData() async{
    // Userコレクションを取得
    var data = await FirebaseFirestore.instance.collection('users').doc('user1').get();
    var fields = data.data();
    _addLog("Name : ${fields?['name']} / Age : ${fields?['age']}");
  }

  /// 取得(モデル)
  Future<void> _getDataModel() async{
    // Userコレクションを取得
    var users = await FirebaseFirestore.instance.collection ('users').get();
    var persons = users.docs.map((doc) => PersonModel(
      name: doc['name'],
      age: int.parse(doc['age'].toString())
    )).toList();
    _addLog("data length${persons.length}");
    for (var model in persons) {
      _addLog("Name : ${model.name} / Age : ${model.age}");
    }
  }

  /// 削除
  Future<void> _deleteData() async{
    // Userコレクションを取得
    var data = await FirebaseFirestore.instance.collection('users').doc('user1').get();
    data.reference.delete();
  }
}