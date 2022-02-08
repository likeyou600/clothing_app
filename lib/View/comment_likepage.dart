import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/View/community_profile_anothersee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'notification_click_postpage.dart';

class comment_likepage extends StatefulWidget {
  final comment_id;
  comment_likepage(this.comment_id);

  @override
  State<comment_likepage> createState() => _comment_likepageState();
}

class _comment_likepageState extends State<comment_likepage> {
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
        future: getdata(widget.comment_id),
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

getdata(String comment_id) async {
  DocumentSnapshot comment = await FirebaseFirestore.instance
      .collection('comments')
      .doc(comment_id)
      .get();
  return comment;
}
