import 'package:clothing_app/View/community.dart';
import 'package:clothing_app/View/community_upload.dart';
import 'package:clothing_app/View/calander/calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'View/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDzQmyRJsiSZk57kG4AUXI9cwGE994J8nw',
          appId: '1:878404736647:android:3a6e8b90003df9aa694a22',
          messagingSenderId: 'messagingSenderId',
          projectId: 'clothing-55e8a'));

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
    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: user == null ? Auth() : community(),
          routes: <String, WidgetBuilder>{
            '/auth': (BuildContext context) => Auth(),
            '/community': (BuildContext context) => community(),
            '/community_upload': (BuildContext context) => community_upload(),
            '/calendar': (BuildContext context) => calendar(),
          },
        );
      },
      maximumSize: Size(475.0, 812.0), // Maximum size
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor:
          Color.fromRGBO(232, 215, 199, 0.5), // Background color/white space
    );
  }
}
