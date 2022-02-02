import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controller/ImageController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(upload());
}

class upload extends StatefulWidget {
  const upload({Key? key}) : super(key: key);

  @override
  _uploadState createState() => _uploadState();
}

class _uploadState extends State<upload> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              MaterialButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                elevation: 5.0,
                height: 60,
                onPressed: () async {
                  getImage();
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      '/post', (Route<dynamic> route) => false);
                },
                child: const Text(
                  "  Get image",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                color: Colors.blue,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/auth', (Route<dynamic> route) => false);
                    setState(() {});
                  },
                  child: const Text('Log out'))
            ])),
      ),
    );
  }
}
