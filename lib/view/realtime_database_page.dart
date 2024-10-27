import 'dart:developer' as developer;

import 'package:flutter/material.dart';

// Firebase Realtime Databaseを利用するために以下を追加
import 'package:firebase_database/firebase_database.dart';

import '../util/button_util.dart';


class RealtimeDatabasePage extends StatefulWidget {

  const RealtimeDatabasePage({super.key});
  @override
  State<RealtimeDatabasePage> createState() => _RealtimeDatabasePageState();
}

class _RealtimeDatabasePageState extends State<RealtimeDatabasePage> {

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
        title: const Text("Firebase Realtime Database Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonUtil.create(
                onPressed: () {
                  _initData();
                },
                icon: Icons.format_color_reset,
                label: "初期化"
            ),

            ButtonUtil.create(
                onPressed: () async {
                  final ref = FirebaseDatabase.instance.ref('users/1');
                  final snapshot = await ref.get();
                  if(snapshot.value != null){
                    developer.log("value : ${snapshot.value}");
                  }else{
                    developer.log("value : null");
                  }
                },
                icon: Icons.download,
                label: "読み込み(get)"
            ),

            ButtonUtil.create(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users/1');
                final event = await ref.once(DatabaseEventType.value);
                if(event.snapshot.value != null){
                  developer.log("value : ${event.snapshot.value}");
                }else{
                  developer.log("value : null");
                }
              },
              icon: Icons.download,
              label: "読み込み(once)",
            ),

            ButtonUtil.create(
              onPressed: () async{
                final ref = FirebaseDatabase.instance.ref('users/3');
                await ref.set({
                  'name':'name3',
                  'age':'42'
                });
              },
              icon: Icons.upload,
              label: "書き込み(set)",
            ),

            ButtonUtil.create(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users');
                var newRef = ref.push();
                await newRef.set({
                  'name':'name4',
                  'age':'55'
                });
              },
                icon: Icons.add,
              label: "追加(push)",
            ),

            ButtonUtil.create(
              onPressed: () async{
                final ref = FirebaseDatabase.instance.ref('users/3');
                await ref.update({
                  'age':'44'
                });
              },
              icon: Icons.update,
              label: "更新(update)",
            ),

            ButtonUtil.create(
              onPressed: () async{
                final ref = FirebaseDatabase.instance.ref('users/3');
                await ref.set(null);
              },
              icon: Icons.delete,
              label: "削除",
            ),

            ButtonUtil.create(
              onPressed: () async{
                final ref = FirebaseDatabase.instance.ref('users/3');
                var result = await ref.runTransaction((value){
                  if(value == null){
                    return Transaction.abort();
                  }
                  Map<String, dynamic> post = Map<String, dynamic>.from(value as Map);
                  post['name'] = 'hogehoge';
                  post['age'] = 101;
                  return Transaction.success(post);
                });
              },
              icon: Icons.upload,
              label: "更新(トランザクション)",
            ),

            ButtonUtil.create(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users');
                final query = ref.orderByChild('age');

                final snapshot = await query.get();
                developer.log("- get() -> value --------------------------------");
                developer.log("value_1 : ${snapshot.value}");

                developer.log("- get() -> children --------------------------------");
                for (var element in snapshot.children) {
                  developer.log("value_2 : ${element.value}");
                }

                developer.log("- once() -> children --------------------------------");
                final onceEvent1 = await query.once();
                for (var element in onceEvent1.snapshot.children) {
                  developer.log("value_3 : ${element.value}");
                }

                developer.log("- once() -> value --------------------------------");
                var items3 = onceEvent1.snapshot.value;
                developer.log("value_4 : $items3");

              },
              icon: Icons.download,
              label: "並び替え",
            ),

            ButtonUtil.create(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users');
                final query = ref.orderByChild('age').startAt(20, key:'age');
//                final query = ref.startAt(20, key:'age');

                final snapshot = await query.get();
                developer.log("- get() -> value --------------------------------");
                developer.log("value_1 : ${snapshot.value}");

                developer.log("- get() -> children --------------------------------");
                for (var element in snapshot.children) {
                  developer.log("value_2 : ${element.value}");
                }

                developer.log("- once() -> children --------------------------------");
                final onceEvent1 = await query.once();
                for (var element in onceEvent1.snapshot.children) {
                  developer.log("value_3 : ${element.value}");
                }

                developer.log("- once() -> value --------------------------------");
                var items3 = onceEvent1.snapshot.value;
                developer.log("value_4 : $items3");

              },
              icon: Icons.download,
              label: "絞り込み",
            ),
          ],
        ),
      ),
    );
  }

  /// データ初期化
  void _initData(){
    final ref = FirebaseDatabase.instance.ref('users');
    ref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        developer.log("onValue : ${snapshot.value}");
      } else {
        developer.log("onValue : null");
      }
    });
    ref.onChildChanged.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        developer.log("onChildChanged : ${snapshot.value}");
      } else {
        developer.log("onChildChanged : null");
      }
    });
    ref.onChildMoved.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        developer.log("onChildMoved : ${snapshot.value}");
      } else {
        developer.log("onChildMoved : null");
      }
    });
    ref.onChildAdded.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        developer.log("onChildAdded : ${snapshot.value}");
      } else {
        developer.log("onChildAdded : null");
      }
    });
    ref.onChildRemoved.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        developer.log("onChildRemoved : ${snapshot.value}");
      } else {
        developer.log("onChildRemoved : null");
      }
    });
  }

}