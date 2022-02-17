import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Controller/AuthController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app/main.dart';

final TextEditingController _descriptionController = TextEditingController();

class editnickname extends StatefulWidget {
  @override
  State<editnickname> createState() => _editnicknameState();
}

class _editnicknameState extends State<editnickname> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text('修改nickname'),
          actions: <Widget>[
            TextButton(
              onPressed: () => [
                Editnickname(_descriptionController.text),
                Navigator.of(context).pop()
              ],
              child: const Text(
                "送出修改",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            )
          ]),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserPicWidget(user!.uid, 23),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: newnicknameWidget()),
            ],
          ),
        ],
      ),
    );
  }
}

//取得old nickname
Future getoldnickname() async {
  DocumentSnapshot users =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  var nickname = (users.data()! as Map<String, dynamic>)['nickname'];
  return nickname;
}

class newnicknameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getoldnickname(),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _descriptionController..text = snapshot.data,
          decoration: const InputDecoration(
              hintText: "輸入新名稱... ...", border: InputBorder.none),
          maxLines: 5,
        );
      },
    );
  }
}
