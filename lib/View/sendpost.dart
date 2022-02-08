import 'dart:developer';

import 'package:clothing_app/Controller/AuthController.dart';
import 'package:clothing_app/View/community.dart';
import 'package:clothing_app/Controller/PostImageController.dart';
import 'package:flutter/material.dart';

class sendpost extends StatefulWidget {
  final String imgurl;
  sendpost(this.imgurl);
  @override
  _sendpostState createState() => _sendpostState();
}

class _sendpostState extends State<sendpost> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),

      appBar: AppBar(
        backgroundColor: Color.fromRGBO(174, 221, 239, 1),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                '/community', (Route<dynamic> route) => false)),
        title: const Text(
          '新貼文',
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            onPressed: () => [
              // savepictodb(_descriptionController.text, widget.imgurl),
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/community', (Route<dynamic> route) => false)
            ],
            child: const Text(
              "發布",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      // POST FORM
      body: Column(
        children: <Widget>[
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserPicWidget(user!.uid, 23),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "輸入說明文字... ...", border: InputBorder.none),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 60.0,
                width: 60.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: NetworkImage(widget.imgurl)
                            // MemoryImage(_file!)
                            )),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
