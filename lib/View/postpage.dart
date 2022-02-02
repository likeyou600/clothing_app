import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widget/postWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: postpage()));
}

class postpage extends StatefulWidget {
  const postpage({Key? key}) : super(key: key);

  @override
  _postpageState createState() => _postpageState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

final Stream<QuerySnapshot> posts =
    FirebaseFirestore.instance.collection('posts').snapshots();

class _postpageState extends State<postpage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Center(
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

              return postWidget(posts);
            },
          );
        },
      ),
    );
  }
}
