import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Model/UserModel.dart';
import 'package:clothing_app/View/reported.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//創立用戶
Future createUser(UserModel userModel) async {
  final users =
      FirebaseFirestore.instance.collection('users').doc(userModel.uid);
  final json = userModel.toMap();
  await users.set(json);
}

//取得nickname
Future getnickname(String user_id) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user_id).get();
  var nickname = (userDoc.data()! as Map<String, dynamic>)['nickname'];
  return nickname;
}

class UserNicknameWidget extends StatelessWidget {
  final String uid;

  UserNicknameWidget(
    this.uid,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getnickname(uid),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          snapshot.data,
          textAlign: TextAlign.start,
        );
      },
    );
  }
}

//取得頭貼
Future getuserpic(String user_id, double radius) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user_id).get();
  var userpic = (userDoc.data()! as Map<String, dynamic>)['userpic'];
  return userpic;
}

class UserPicWidget extends StatelessWidget {
  final String uid;
  final double radius;
  UserPicWidget(this.uid, this.radius);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getuserpic(uid, radius),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircleAvatar(
              backgroundColor: Colors.grey,
              radius: radius,
            );
            break;
          case ConnectionState.done:
            if (snapshot.data != null)
              return CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(snapshot.data),
                radius: radius,
              );
            return Container();
        }
      },
    );
  }
}
//取得檢舉按鈕

Future getuseradmin() async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  return userDoc;
}

class reportedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getuseradmin(),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container();
            break;
          case ConnectionState.done:
            if (snapshot.data != null) {
              if (snapshot.data['admin'] == true) {
                return IconButton(
                    icon: const Icon(
                      Icons.report_gmailerrorred_rounded,
                      size: 35,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return reported();
                      }));
                    });
              }
            }
            return Container();
        }
      },
    );
  }
}
