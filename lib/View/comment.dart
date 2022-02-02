import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Model/CommentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            body: Column(children: [
      Expanded(
          child: Container(
        decoration:
            new BoxDecoration(color: Color.fromRGBO(232, 215, 199, 100)),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      const CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.black12,
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/250?image=9')),
                      const SizedBox(width: 12.0),
                      UserNicknameWidget(widget.postData['poster']),
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
                      )
                    ],
                  ),
                  Text(
                    widget.postData['content'].toString(),
                    textAlign: TextAlign.start,
                  )
                ],
              )),
          StreamBuilder<QuerySnapshot>(
            stream: comments,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('loading'));
              }
              final comments_data = snapshot.requireData;

              return ListView.builder(
                itemCount: comments_data.size,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  DateTime comment_time = DateTime.fromMillisecondsSinceEpoch(
                      comments_data.docs[index]['comment_time']);

                  var difference =
                      DateTime.now().difference(comment_time).inSeconds;
                  var out = '';
                  if (difference > 86400) {
                    difference = DateTime.now().difference(comment_time).inDays;
                    out = difference.toString() + "天";
                  } else if (difference > 3600) {
                    difference =
                        DateTime.now().difference(comment_time).inHours;
                    out = difference.toString() + "小時";
                  } else if (difference > 60) {
                    difference =
                        DateTime.now().difference(comment_time).inMinutes;
                    out = difference.toString() + "分鐘";
                  } else {
                    out = difference.toString() + "秒";
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage:
                          NetworkImage('https://picsum.photos/250?image=9'),
                    ),
                    title: Row(
                      children: [
                        UserNicknameWidget(comments_data.docs[index]['uid']),
                        //  style: const TextStyle(
                        //     fontSize: 20,
                        //     color: Colors.red,
                        //     fontWeight: FontWeight.w700,
                        //   )
                        const SizedBox(
                          width: 10,
                        ),
                        Text(comments_data.docs[index]['comment']),
                        // style: const TextStyle(
                        //     fontSize: 20,
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w500,
                        //   ),
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

                        Text(
                          comments_data.docs[index]['likes'].length.toString() +
                              "個讚",
                        )
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        likecomment(comments_data.docs[index].id);
                      },
                      child: SvgPicture.asset(
                        "assets/favorite.svg",
                        width: 20.0,
                        color: comments_data.docs[index]['likes']
                                .contains(user!.uid)
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ]),
      )),
      TextFormField(
          controller: commentController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: isButtonActive
                  ? () async {
                      setState(() {
                        isButtonActive = false;
                      });
                      commentpost(CommentModel(
                          post_id: widget.postData.id,
                          uid: widget.postData['poster'],
                          comment: commentController.text,
                          comment_time: DateTime.now(),
                          likes: []));
                      commentController.clear();
                    }
                  : null,
            ),
          ))
    ])));
  }
}
