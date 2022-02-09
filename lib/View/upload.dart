import 'package:clothing_app/View/demo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
                  // final imgurl = await getImage();
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  //   return sendpost(imgurl);
                  // }));
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return demo();
                  }));
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
            ])),
      ),
    );
  }
}
