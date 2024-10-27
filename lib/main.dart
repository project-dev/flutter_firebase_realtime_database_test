import 'package:flutter/material.dart';

// Firebaseを利用する為に以下2つを追加
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'view/main_page.dart';



// Firebase Realtime Databaseを利用するために以下を追加
import 'package:firebase_database/firebase_database.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

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
      home: const MainPage(),
    );
  }
}


