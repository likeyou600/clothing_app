import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/View/comment.dart';
import 'package:clothing_app/View/community_profile_anothersee.dart';
import 'package:clothing_app/View/likepage.dart';
import 'package:clothing_app/Widget/like_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Controller/PostController.dart';
import '../constants.dart';

class reported_postWidget extends StatefulWidget {
  final postData;

  reported_postWidget(this.postData);
  @override
  _reported_postWidgetState createState() => _reported_postWidgetState();
}

class _reported_postWidgetState extends State<reported_postWidget> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget(int index) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          widget.postData['postpics'][index],
          fit: BoxFit.cover,
        ),
      );
    }

    User? user = FirebaseAuth.instance.currentUser;
    DateTime publish_time =
        DateTime.fromMillisecondsSinceEpoch(widget.postData['publish_time']);

    var difference = DateTime.now().difference(publish_time).inSeconds;
    var out = '';
    if (difference > 86400) {
      difference = DateTime.now().difference(publish_time).inDays;
      out = difference.toString() + "天前";
    } else if (difference > 3600) {
      difference = DateTime.now().difference(publish_time).inHours;
      out = difference.toString() + "小時前";
    } else if (difference > 60) {
      difference = DateTime.now().difference(publish_time).inMinutes;
      out = difference.toString() + "分鐘前";
    } else {
      out = difference.toString() + "秒前";
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 8.0,
            ),
            child: Row(
              children: <Widget>[
                UserPicWidget(widget.postData['poster'], 20),
                const SizedBox(width: 12.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return community_profile_anothersee(
                          widget.postData['poster']);
                    }));
                  },
                  child: UserNicknameWidget(widget.postData['poster']),
                ),
                Expanded(child: Container()),
                GestureDetector(
                    onTap: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      deletePost(
                                        widget.postData.id,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    child: Text('刪除')),
                                TextButton(
                                    onPressed: () {
                                      canclereportedpost(
                                        widget.postData.id,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    child: Text('退回,取消檢舉'))
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 8.0,
              ),
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isLikeAnimating = true;
                  });
                  doublelikepost(widget.postData.id);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 0,
                              blurRadius: 15),
                        ],
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250.0,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.postData['postpics'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10.0),
                                  child: Stack(
                                    children: <Widget>[
                                      imageWidget(index),
                                    ],
                                  ),
                                );
                              })),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 100,
                        ),
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 0.0,
              ),
              child: Container(
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            likepost(widget.postData.id);
                          },
                          child: SvgPicture.asset(
                            "assets/favorite.svg",
                            width: 27.0,
                            color: widget.postData['likes'].contains(user!.uid)
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return comment(widget.postData);
                            }));
                          },
                          child: SvgPicture.asset(
                            "assets/comment.svg",
                            width: 27.0,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        collectionpost(widget.postData.id);
                      },
                      child: SvgPicture.asset(
                        "assets/bookmark.svg",
                        width: 20.0,
                        color: widget.postData['collections'].contains(user.uid)
                            ? Colors.red
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 40.0, bottom: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return likepage(widget.postData.id);
                  }));
                },
                child: Text(
                  widget.postData['likes'].length.toString() + " 個讚",
                  style: kTitleStyle,
                ),
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 40.0, bottom: 5.0, right: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UserNicknameWidget(widget.postData['poster']),
                const SizedBox(
                  height: 5,
                ),
                Text(widget.postData['content'].toString(), softWrap: true)
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 40.0, bottom: 5.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return comment(widget.postData);
                    }));
                  },
                  child: commentnumberWidget(widget.postData.id))),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 5.0),
            child: Text(
              out,
              style: kTimeStyle,
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
    ;
  }
}