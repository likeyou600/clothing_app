import 'package:clothing_app/View/rank_postPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class community_ranking extends StatefulWidget {
  @override
  State<community_ranking> createState() => _community_rankingState();
}

class _community_rankingState extends State<community_ranking> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text("收藏排行")),
      body: ListView(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('collections_number', descending: true)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                  return Container(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return rank_postPage(index);
                          }));
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch, //add this
                            children: <Widget>[
                              Expanded(
                                child: Image.network(
                                  snap['postpics'][0],
                                  fit: BoxFit.cover, // add this
                                ),
                              ),
                              Center(
                                child: Container(
                                  child: Text("收藏人數:" +
                                      snap['collections_number'].toString()),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              );
            },
          )
        ],
      ),
    )));
  }
}
