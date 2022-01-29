import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'upload.dart';
import 'Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: user == null ?Auth():upload(),
      routes: <String, WidgetBuilder>{
        '/auth': (BuildContext context) => Auth(),
        '/upload' : (BuildContext context) => upload(),
        // '/screen3' : (BuildContext context) => new Screen3(),
        // '/screen4' : (BuildContext context) => new Screen4()
      },
    );
  }
}
