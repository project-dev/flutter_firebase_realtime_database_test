import 'dart:developer' as developer;

import 'package:flutter/material.dart';

// Firebaseを利用する為に以下2つを追加
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Firebase Realtime Databaseを利用するために以下を追加
import 'package:firebase_database/firebase_database.dart';

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // firebaseの初期化処理
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

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
            TextButton.icon(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users/1');
                final snapshot = await ref.get();
                if(snapshot.value != null){
                  developer.log("value : ${snapshot.value}");
                }else{
                  developer.log("value : null");
                }
              },
              icon: const Icon(Icons.download),
              label: const Text("読み込み(get)"),
            ),
            TextButton.icon(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users/1');
                final event = await ref.once(DatabaseEventType.value);
                if(event.snapshot.value != null){
                  developer.log("value : ${event.snapshot.value}");
                }else{
                  developer.log("value : null");
                }
              },
              icon: const Icon(Icons.download),
              label: const Text("読み込み(once)"),
            ),
            TextButton.icon(
                onPressed: () async{
                  final ref = FirebaseDatabase.instance.ref('users/3');
                  await ref.set({
                    'name':'name3',
                    'age':'42'
                  });
                },
                icon: const Icon(Icons.upload),
                label: const Text("書き込み(set)"),
            ),
            TextButton.icon(
              onPressed: () async {
                final ref = FirebaseDatabase.instance.ref('users');
                var newRef = ref.push();
                await newRef.set({
                  'name':'name4',
                  'age':'55'
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("追加(push)"),
            ),
            TextButton.icon(
              onPressed: () async{
                final ref = FirebaseDatabase.instance.ref('users/3');
                await ref.update({
                  'age':'44'
                });
              },
              icon: const Icon(Icons.update),
              label: const Text("更新(update)"),
            ),
            TextButton.icon(
              onPressed: () async{
                final ref = FirebaseDatabase.instance.ref('users/3');
                await ref.set(null);
              },
              icon: const Icon(Icons.delete),
              label: const Text("削除"),
            ),
            TextButton.icon(
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
              icon: const Icon(Icons.upload),
              label: const Text("更新(トランザクション)"),
            ),
            TextButton.icon(
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
              icon: const Icon(Icons.download),
              label: const Text("並び替え"),
            ),
            TextButton.icon(
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
              icon: const Icon(Icons.download),
              label: const Text("絞り込み"),
            ),
          ],
        ),
      ),
    );
  }
}
