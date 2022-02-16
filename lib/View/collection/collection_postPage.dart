import 'package:clothing_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'collection_postWidget.dart';

class collection_postPage extends StatefulWidget {
  final index;
  collection_postPage(this.index);
  @override
  _collection_postPageState createState() => _collection_postPageState();
}

class _collection_postPageState extends State<collection_postPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
        .collection('posts')
        .where('collections', arrayContainsAny: [user!.uid]).snapshots();
    ItemScrollController _scrollController = ItemScrollController();

    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(index: widget.index);
    });
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
        child: StreamBuilder<QuerySnapshot>(
          stream: posts,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('loading'));
            }
            final posts_data = snapshot.requireData;

            return ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemCount: posts_data.size,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                var posts = posts_data.docs[index];

                return collection_postWidget(posts);
              },
            );
          },
        ),
      ),
    ));
  }
}
