import 'package:clothing_app/Widget/User_postWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User_postpage extends StatefulWidget {
  final String poster;
  User_postpage(this.poster);
  @override
  _User_postpageState createState() => _User_postpageState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

class _User_postpageState extends State<User_postpage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
        .collection('posts')
        .where('poster', isEqualTo: widget.poster)
        .orderBy('publish_time', descending: true)
        .snapshots();

    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text("貼文")),
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

                return User_postWidget(posts);
              },
            );
          },
        ),
      ),
    ));
  }
}
