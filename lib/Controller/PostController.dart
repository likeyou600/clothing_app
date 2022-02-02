import 'dart:developer';

import 'package:clothing_app/Model/CommentModel.dart';
import 'package:clothing_app/Model/PostModel.dart';
import 'package:clothing_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final posts = FirebaseFirestore.instance.collection('posts');
final comments = FirebaseFirestore.instance.collection('comments');

User? user = FirebaseAuth.instance.currentUser;

//創立貼文
Future createPost(PostModel postModel) async {
  final json = postModel.toMap();
  await posts.doc().set(json);
}

//按貼文讚
likepost(String post_id) async {
  DocumentSnapshot doc = await posts.doc(post_id).get();
  if ((doc.data()! as dynamic)['likes'].contains(user!.uid)) {
    await posts.doc(post_id).update({
      'likes': FieldValue.arrayRemove([user!.uid]),
    });
  } else {
    await posts.doc(post_id).update({
      'likes':
          FieldValue.arrayUnion([user!.uid]), //因欄位是 Array 資料型別時 故採用FieldValue
    });
  }
}

doublelikepost(String post_id) async {
  DocumentSnapshot doc = await posts.doc(post_id).get();
  if ((doc.data()! as dynamic)['likes'].contains(user!.uid)) {
  } else {
    await posts.doc(post_id).update({
      'likes':
          FieldValue.arrayUnion([user!.uid]), //因欄位是 Array 資料型別時 故採用FieldValue
    });
  }
}

//按貼文收藏
collectionpost(String post_id) async {
  DocumentSnapshot doc = await posts.doc(post_id).get();
  if ((doc.data()! as dynamic)['collections'].contains(user!.uid)) {
    await posts.doc(post_id).update({
      'collections': FieldValue.arrayRemove([user!.uid]),
    });
  } else {
    await posts.doc(post_id).update({
      'collections':
          FieldValue.arrayUnion([user!.uid]), //因欄位是 Array 資料型別時 故採用FieldValue
    });
  }
}

//留言貼文
Future commentpost(CommentModel commentModel) async {
  final json = commentModel.toMap();
  await comments.doc().set(json);
}

//按讚留言
likecomment(String comment_id) async {
  DocumentSnapshot doc = await comments.doc(comment_id).get();
  if ((doc.data()! as dynamic)['likes'].contains(user!.uid)) {
    await comments.doc(comment_id).update({
      'likes': FieldValue.arrayRemove([user!.uid]),
    });
  } else {
    await comments.doc(comment_id).update({
      'likes':
          FieldValue.arrayUnion([user!.uid]), //因欄位是 Array 資料型別時 故採用FieldValue
    });
  }
}

//取得留言數
Future getcommentnumber(String post_id) async {
  QuerySnapshot<Map<String, dynamic>> comments = await FirebaseFirestore
      .instance
      .collection('comments')
      .where('post_id', isEqualTo: post_id)
      .get();
  var commentnumber = comments.size;
  return commentnumber;
}

class commentnumberWidget extends StatelessWidget {
  final String post_id;

  commentnumberWidget(
    this.post_id,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getcommentnumber(post_id),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          "查看全部" + snapshot.data.toString() + "則留言",
          style: kSubtitleStyle.copyWith(
            color: Colors.black38,
            fontSize: 15.0,
          ),
        );
      },
    );
  }
}
