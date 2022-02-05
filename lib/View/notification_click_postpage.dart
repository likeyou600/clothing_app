import 'package:clothing_app/Widget/notification_click_postWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class notification_click_postpage extends StatefulWidget {
  final post_id;
  notification_click_postpage(this.post_id);

  @override
  _notification_click_postpageState createState() =>
      _notification_click_postpageState();
}

class _notification_click_postpageState
    extends State<notification_click_postpage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text("貼文")),
      body: Container(
        child: FutureBuilder(
          future: getpic(widget.post_id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('loading'));
            }
            final posts_data = snapshot.requireData;

            return ListView.builder(
              itemCount: 1,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return notification_click_postWidget(posts_data);
              },
            );
          },
        ),
      ),
    ));
  }
}

getpic(String post_id) async {
  DocumentSnapshot posts =
      await FirebaseFirestore.instance.collection('posts').doc(post_id).get();
  return posts;
}
