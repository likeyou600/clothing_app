import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'upload.dart';
import 'postWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: community()));
}

class community extends StatefulWidget {
  const community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

class _communityState extends State<community> {
  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
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
                  var uid = posts_data.docs[index]['poster'].toString();

                  return postWidget(posts_data.docs[index]);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // log();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => upload()));
          },
        ),
      ),
    );
  }
}

Future<String> getnickname(String uid) async {
  var nickname = '';
  await users
      .where("uid", isEqualTo: uid)
      .get()
      .then((value) => value.docs.forEach((doc) => nickname = doc["nickname"]));
  return nickname;
}

class UserNicknameWidget extends StatelessWidget {
  final String uid;

  UserNicknameWidget(
    this.uid,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getnickname(uid),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          snapshot.data,
          textAlign: TextAlign.start,
        );
      },
    );
  }
}
