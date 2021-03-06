import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Model/CommentModel.dart';
import 'package:clothing_app/View/community_profile_anothersee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothing_app/main.dart';

import 'comment_likepage.dart';

class comment extends StatefulWidget {
  final postData;
  comment(this.postData);
  @override
  _commentState createState() => _commentState();
}

class _commentState extends State<comment> {
  final commentController = TextEditingController();
  bool isButtonActive = false;
  @override
  void initState() {
    //送出按鈕鎖定
    super.initState();
    commentController.addListener(() {
      final isButtonActive = commentController.text.isNotEmpty;

      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> comments = FirebaseFirestore.instance
        .collection('comments')
        .where('post_id', isEqualTo: widget.postData.id.toString())
        .orderBy('comment_time', descending: true)
        .snapshots();

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color.fromRGBO(232, 215, 199, 1),
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context)),
                backgroundColor: Color.fromRGBO(174, 221, 239, 1),
                title: Text("留言")),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      child: Container(
                                          child: ListTile(
                                              leading: UserPicWidget(
                                                  widget.postData['poster'],
                                                  20),
                                              title: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return community_profile_anothersee(
                                                        widget.postData[
                                                            'poster']);
                                                  }));
                                                },
                                                child: UserNicknameWidget(
                                                    widget.postData['poster']),
                                              ),
                                              subtitle: Text(
                                                  widget.postData['content']
                                                      .toString(),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ))))),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.black54,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: comments,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(child: Text('loading'));
                                      }
                                      final comments_data =
                                          snapshot.requireData;

                                      return ListView.builder(
                                        itemCount: comments_data.size,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          DateTime comment_time = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  comments_data.docs[index]
                                                      ['comment_time']);

                                          var difference = DateTime.now()
                                              .difference(comment_time)
                                              .inSeconds;
                                          var out = '';
                                          if (difference > 86400) {
                                            difference = DateTime.now()
                                                .difference(comment_time)
                                                .inDays;
                                            out = difference.toString() + "天";
                                          } else if (difference > 3600) {
                                            difference = DateTime.now()
                                                .difference(comment_time)
                                                .inHours;
                                            out = difference.toString() + "小時";
                                          } else if (difference > 60) {
                                            difference = DateTime.now()
                                                .difference(comment_time)
                                                .inMinutes;
                                            out = difference.toString() + "分鐘";
                                          } else {
                                            out = difference.toString() + "秒";
                                          }
                                          return Container(
                                              child: ListTile(
                                            leading: UserPicWidget(
                                                comments_data.docs[index]
                                                    ['uid'],
                                                20),
                                            title: Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return community_profile_anothersee(
                                                            comments_data
                                                                    .docs[index]
                                                                ['uid']);
                                                      }));
                                                    },
                                                    child: UserNicknameWidget(
                                                        comments_data
                                                                .docs[index]
                                                            ['uid'])),

                                                //  style: const TextStyle(
                                                //     fontSize: 20,
                                                //     color: Colors.red,
                                                //     fontWeight: FontWeight.w700,
                                                //   )
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        comments_data
                                                                .docs[index]
                                                            ['comment'],
                                                        softWrap: true)),
                                              ],
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(out),
                                                // style: const TextStyle(
                                                //     fontSize: 12,
                                                //     color: Colors.white,
                                                //   ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return comment_likepage(
                                                            comments_data
                                                                .docs[index]
                                                                .id);
                                                      }));
                                                    },
                                                    child: Text(
                                                      comments_data
                                                              .docs[index]
                                                                  ['likes']
                                                              .length
                                                              .toString() +
                                                          "個讚",
                                                    ))
                                              ],
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () {
                                                likecomment(comments_data
                                                    .docs[index].id);
                                              },
                                              child: SvgPicture.asset(
                                                "assets/favorite.svg",
                                                width: 20.0,
                                                color: comments_data.docs[index]
                                                            ['likes']
                                                        .contains(user!.uid)
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                          ));
                                        },
                                      );
                                    },
                                  )
                                ]),
                          ))),
                  TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(234, 219, 128, 1),
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: isButtonActive
                              ? () async {
                                  setState(() {
                                    isButtonActive = false;
                                  });
                                  commentpost(CommentModel(
                                      post_id: widget.postData.id,
                                      poster: widget.postData['poster'],
                                      postpics: widget.postData['postpics'],
                                      uid: user!.uid,
                                      comment: commentController.text,
                                      comment_time: DateTime.now(),
                                      likes: []));
                                  commentController.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              : null,
                        ),
                      ))
                ]))));
  }
}
