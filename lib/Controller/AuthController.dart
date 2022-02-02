import 'package:clothing_app/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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
