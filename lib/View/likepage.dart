import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/View/community_profile_anothersee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'notification_click_postpage.dart';

class likepage extends StatefulWidget {
  final post_id;
  likepage(this.post_id);

  @override
  State<likepage> createState() => _likepageState();
}

class _likepageState extends State<likepage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text("說讚的用戶")),
      body: Center(
          child: FutureBuilder(
        future: getdata(widget.post_id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final likes_data = snapshot.requireData;

          return ListView.builder(
              itemCount: likes_data['likes'].length,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                var likes = likes_data['likes'][index];

                return ListTile(
                    leading: UserPicWidget(likes, 20),
                    title: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return community_profile_anothersee(likes);
                            }));
                          },
                          child: UserNicknameWidget(likes),
                        )
                      ],
                    ));
              });
        },
      )),
    );
  }
}

getdata(String post_id) async {
  DocumentSnapshot posts =
      await FirebaseFirestore.instance.collection('posts').doc(post_id).get();
  return posts;
}
