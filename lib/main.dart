import 'package:clothing_app/View/comment.dart';
import 'package:clothing_app/View/community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'View/upload.dart';
import 'View/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDA7MvDgUaOtGPYbDGJY9_QsYM4rI58Gu8',
          appId: '1:263023150372:android:03b2965ec676e8a8049fb1',
          messagingSenderId: 'messagingSenderId',
          projectId: 'clothing-f7788'));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: user == null ? Auth() : community(),
      routes: <String, WidgetBuilder>{
        '/auth': (BuildContext context) => Auth(),
        '/upload': (BuildContext context) => upload(),
        '/community': (BuildContext context) => community(),
      },
    );
  }
}
