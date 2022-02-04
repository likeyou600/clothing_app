import 'package:clothing_app/Controller/PostController.dart';

import 'package:clothing_app/View/collection_postPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class community_collection extends StatefulWidget {
  final uid;

  community_collection(this.uid);
  @override
  State<community_collection> createState() => _community_collectionState();
}

class _community_collectionState extends State<community_collection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text("收藏的貼文")),
      body: ListView(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('collections', arrayContainsAny: [user!.uid]).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                  return Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return collection_postPage();
                            }));
                          },
                          child: Image(
                            image: NetworkImage(snap['postpics'][0]),
                            fit: BoxFit.cover,
                          )));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
