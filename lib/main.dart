import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'upload.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: Community()
  ));
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final textController = TextEditingController();
  @override

  CollectionReference posts= FirebaseFirestore.instance
      .collection('posts');

  // posts.add({
  // 'poster':textController.text
  // });

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:TextField(
            controller: textController,
          )
        ),
        body: Center(
          child: StreamBuilder(
            stream: posts.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(child: Text('loading'));
              }
              return ListView(
                children: snapshot.data!.docs.map((post){
                  return Center(
                    child: ListTile(
                      title: Text(post['poster'].toString()),
                      onLongPress: (){
                        post.reference.delete();
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => upload()));
          },
        ),
      ),

    );
  }
}

    
    