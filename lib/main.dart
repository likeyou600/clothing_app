import 'package:clothing_app/View/community.dart';
import 'package:clothing_app/View/upload.dart';
import 'package:clothing_app/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'View/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDA7MvDgUaOtGPYbDGJY9_QsYM4rI58Gu8',
          appId: '1:263023150372:android:03b2965ec676e8a8049fb1',
          messagingSenderId: 'messagingSenderId',
          projectId: 'clothing-f7788'));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

User? user = FirebaseAuth.instance.currentUser;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: user == null ? Auth() : community(),
      routes: <String, WidgetBuilder>{
        '/auth': (BuildContext context) => Auth(),
        '/community': (BuildContext context) => community(),
        '/upload': (BuildContext context) => upload(),
        '/calendar': (BuildContext context) => calendar(),
      },
    );
  }
}
