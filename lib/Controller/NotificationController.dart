// import 'package:clothing_app/Controller/PostController.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// //取得照片
// Future getpic(String post_id) async {
//   DocumentSnapshot posts =
//       await FirebaseFirestore.instance.collection('posts').doc(post_id).get();
//       return posts;
// }

// class getcommentWidget extends StatelessWidget {
//   final String post_id;
//   getcommentWidget(this.post_id);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//           stream: getpic(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return Center(child: Text('loading'));
//             }
//             final posts_data = snapshot.requireData;

//             return ListView.builder(
//               itemCount: posts_data.size,
//               scrollDirection: Axis.vertical,
//               shrinkWrap: true,
//               physics: ScrollPhysics(),
//               itemBuilder: (context, index) {
//                 var posts = posts_data.docs[index];

//                 return notification_click_postWidget(posts);
//               },
//             );
//           },
//         )
//   }
// }
