import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Controller/UserImageController.dart';
import 'package:clothing_app/View/User_postPage.dart';
import 'package:clothing_app/View/community_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class community_profile_anothersee extends StatefulWidget {
  final uid;

  community_profile_anothersee(this.uid);
  @override
  State<community_profile_anothersee> createState() =>
      _community_profile_anotherseeState();
}

class _community_profile_anotherseeState
    extends State<community_profile_anothersee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: UserNicknameWidget(widget.uid)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          getuserImage();
                        },
                        child: UserPicWidget(widget.uid, 40)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                postnumberWidget(widget.uid),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: UserNicknameWidget(widget.uid)),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('poster', isEqualTo: widget.uid)
                .orderBy('publish_time', descending: true)
                .get(),
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
                              return User_postpage(snap['poster'], index);
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
