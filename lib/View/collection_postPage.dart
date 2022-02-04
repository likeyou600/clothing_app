import 'package:clothing_app/Widget/User_postWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class collection_postPage extends StatefulWidget {
  @override
  _collection_postPageState createState() => _collection_postPageState();
}

class _collection_postPageState extends State<collection_postPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
        .collection('posts')
        .where('collections', arrayContainsAny: [user!.uid])
        .orderBy('publish_time', descending: true)
        .snapshots();
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
