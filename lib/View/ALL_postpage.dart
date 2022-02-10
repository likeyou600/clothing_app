import 'package:clothing_app/calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widget/ALL_postWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: ALL_postpage()));
}

class ALL_postpage extends StatefulWidget {
  const ALL_postpage({Key? key}) : super(key: key);

  @override
  _ALL_postpageState createState() => _ALL_postpageState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
    .collection('posts')
    .orderBy('publish_time', descending: true)
    .snapshots();

class _ALL_postpageState extends State<ALL_postpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          leading: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return calendar();
                }));
              }),
          title: Text("人雲衣雲社群系統")),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: posts,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('loading'));
            }
            final posts_data = snapshot.requireData;

            return ListView.builder(
              itemCount: posts_data.size,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                var posts = posts_data.docs[index];

                return ALL_postWidget(posts);
              },
            );
          },
        ),
      ),
    );
  }
}
