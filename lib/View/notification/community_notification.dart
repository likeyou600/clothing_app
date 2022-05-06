import 'package:clothing_app/Controller/AuthController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clothing_app/main.dart';
import 'package:flutter/material.dart';
import '../community_profile_anothersee.dart';
import 'notification_click_postpage.dart';

class community_notification extends StatefulWidget {
  community_notification({Key? key}) : super(key: key);

  @override
  State<community_notification> createState() => _community_notificationState();
}

class _community_notificationState extends State<community_notification> {
  var check = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text("動態"),
          centerTitle: false,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  check = 1;
                });
              },
              child: const Text(
                "愛心",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  check = 0;
                });
              },
              child: const Text(
                "留言",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            )
          ]),
      body: Center(child: Builder(builder: (context) {
        if (check == 0) {
          return FutureBuilder(
            future: Future.wait([
              getcommentdata(),
              FirebaseFirestore.instance
                  .collection('comments')
                  .where('poster', isEqualTo: user!.uid)
                  .orderBy('comment_time', descending: true)
                  .get()
            ]),
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

              return ListView.builder(
                  itemCount: snapshot.data[0],
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  // shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data[1]! as dynamic).docs[index];

                    if (snap['poster'] != snap['uid']) {
                      DateTime comment_time =
                          DateTime.fromMillisecondsSinceEpoch(
                              snap['comment_time']);

                      var difference =
                          DateTime.now().difference(comment_time).inSeconds;
                      var out = '';
                      if (difference > 86400) {
                        difference =
                            DateTime.now().difference(comment_time).inDays;
                        out = difference.toString() + "天前";
                      } else if (difference > 3600) {
                        difference =
                            DateTime.now().difference(comment_time).inHours;
                        out = difference.toString() + "小時前";
                      } else if (difference > 60) {
                        difference =
                            DateTime.now().difference(comment_time).inMinutes;
                        out = difference.toString() + "分鐘前";
                      } else {
                        out = difference.toString() + "秒前";
                      }
                      return ListTile(
                          leading: UserPicWidget(snap['uid'], 20),
                          title: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return community_profile_anothersee(
                                          snap['uid']);
                                    }));
                                  },
                                  child: UserNicknameWidget(snap['uid'])),
                              Text(" 留言回應了 ："),
                              Expanded(
                                  child: Text(snap['comment'],
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis)),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return notification_click_postpage(
                                          snap['post_id']);
                                    }));
                                  },
                                  child: SizedBox(
                                    height: 60.0,
                                    width: 60.0,
                                    child: AspectRatio(
                                      aspectRatio: 487 / 451,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                alignment:
                                                    FractionalOffset.topCenter,
                                                image: NetworkImage(
                                                    snap['postpics'][0])
                                                // MemoryImage(_file!)
                                                )),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          subtitle: Text(out));
                    } else {
                      return Container();
                    }
                  });
            },
          );
        } else {
          return FutureBuilder(
              future: Future.wait([
                getlikedata(),
                FirebaseFirestore.instance
                    .collection('posts')
                    .where('poster', isEqualTo: user!.uid)
                    .get()
              ]),
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

                return ListView.builder(
                    itemCount: snapshot.data[0],
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                          (snapshot.data[1]! as dynamic).docs[index];
                      var likes_data =
                          (snapshot.data[1]! as dynamic).docs[index]['likes'];
                      if (snap['poster'] != likes_data[index].toString()) {
                        return ListTile(
                          leading:
                              UserPicWidget(likes_data[index].toString(), 20),
                          title: Row(
                            children: [
                              UserNicknameWidget(likes_data[index].toString()),
                              Expanded(child: Text(" 說你的相片讚。")),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return notification_click_postpage(
                                          snap.id);
                                    }));
                                  },
                                  child: SizedBox(
                                    height: 60.0,
                                    width: 60.0,
                                    child: AspectRatio(
                                      aspectRatio: 487 / 451,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                alignment:
                                                    FractionalOffset.topCenter,
                                                image: NetworkImage(
                                                    snap['postpics'][0])
                                                // MemoryImage(_file!)
                                                )),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    });
              });
        }
      })),
    );
  }
}

Future getlikedata() async {
  num likelength = 0;
  await FirebaseFirestore.instance
      .collection('posts')
      .where('poster', isEqualTo: user!.uid)
      .get()
      .then((value) => value.docs.forEach((element) {
            likelength += element['likes'].length;
          }));
  return likelength;
}

Future getcommentdata() async {
  var snapshot = await FirebaseFirestore.instance
      .collection('comments')
      .where('poster', isEqualTo: user!.uid)
      .get();
  num commentlength = snapshot.size;

  return commentlength;
}
