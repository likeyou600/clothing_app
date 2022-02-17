import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Controller/AuthController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app/main.dart';

final TextEditingController _descriptionController = TextEditingController();

class editpost extends StatefulWidget {
  String post_id;
  editpost(this.post_id);
  @override
  State<editpost> createState() => _editpostState();
}

class _editpostState extends State<editpost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text('修改貼文'),
          actions: <Widget>[
            TextButton(
              onPressed: () => [
                Editpost(widget.post_id, _descriptionController.text),
                Navigator.of(context).pop(),
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
                  child: postcontentWidget(widget.post_id)),
            ],
          ),
        ],
      ),
    );
  }
}

//取得貼文content
Future getpostcontent(String post_id) async {
  DocumentSnapshot posts =
      await FirebaseFirestore.instance.collection('posts').doc(post_id).get();
  var content = (posts.data()! as Map<String, dynamic>)['content'];
  return content;
}

class postcontentWidget extends StatelessWidget {
  final String post_id;

  postcontentWidget(
    this.post_id,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getpostcontent(post_id),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          controller: _descriptionController..text = snapshot.data,
          decoration: const InputDecoration(
              hintText: "輸入說明文字... ...", border: InputBorder.none),
          maxLines: 5,
        );
      },
    );
  }
}
