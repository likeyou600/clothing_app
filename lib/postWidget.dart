import 'package:clothing_app/community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'constants.dart';

class postWidget extends StatelessWidget {
  final postData;
  postWidget(this.postData);

  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.black12,
                    backgroundImage:
                        NetworkImage('https://picsum.photos/250?image=9')),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Use the new widget here
                    UserNicknameWidget(postData['poster']),
                    // Text('nickname', style: kTitleStyle),
                  ],
                ),
                Expanded(child: Container()),
                Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Image.network('https://picsum.photos/250?image=9',
                fit: BoxFit.fill),
          ),
          Container(
            height: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/favorite.svg",
                      width: 27.0,
                    ),
                    SizedBox(width: 15.0),
                    SvgPicture.asset(
                      "assets/comment.svg",
                      width: 27.0,
                    ),
                    SizedBox(width: 15.0),
                    SvgPicture.asset(
                      "assets/message.svg",
                      width: 27.0,
                    ),
                    SizedBox(width: 15.0),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(
                  "assets/bookmark.svg",
                  width: 20.0,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
            child: Text(
              "100 likes",
              style: kTitleStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "comment name "),
                  TextSpan(text: "comment "),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
            child: Text(
              "View all number of comments",
              style: kSubtitleStyle.copyWith(
                color: Colors.black38,
                fontSize: 15.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
            child: Text(
              " hours ago",
              style: kTimeStyle,
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
