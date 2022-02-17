import 'dart:developer';

import 'package:clothing_app/Model/OutfitModel.dart';
import 'package:clothing_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final outfits = FirebaseFirestore.instance.collection('outfits');

//儲存上衣
Future savecloth(OutfitModel outfitModel) async {
  if (outfitModel.date != '') {
    DocumentSnapshot check = await FirebaseFirestore.instance
        .collection("outfits")
        .doc(user!.uid + outfitModel.date)
        .get();

    if (check.exists) {
      await FirebaseFirestore.instance
          .collection('outfits')
          .doc(user!.uid + outfitModel.date)
          .update({'clothes': outfitModel.clothes});
    } else {
      final outfits = FirebaseFirestore.instance
          .collection('outfits')
          .doc(user!.uid + outfitModel.date);
      final json = outfitModel.toMap();
      await outfits.set(json);
    }
  }
}
//儲存上衣

//儲存褲子
Future savepant(OutfitModel outfitModel) async {
  if (outfitModel.date != '') {
    DocumentSnapshot check = await FirebaseFirestore.instance
        .collection("outfits")
        .doc(user!.uid + outfitModel.date)
        .get();
    if (check.exists) {
      await FirebaseFirestore.instance
          .collection('outfits')
          .doc(user!.uid + outfitModel.date)
          .update({'pants': outfitModel.pants});
    } else {
      final outfits = FirebaseFirestore.instance
          .collection('outfits')
          .doc(user!.uid + outfitModel.date);
      final json = outfitModel.toMap();
      await outfits.set(json);
    }
  }
}

//取得套裝
getoutfit(String date) {
  final Stream<QuerySnapshot> outfits = FirebaseFirestore.instance
      .collection('outfits')
      .where('poster', isEqualTo: user!.uid)
      .where('date', isEqualTo: date)
      .snapshots();

  return outfits;
}

class outfitWidget extends StatelessWidget {
  final String date;

  outfitWidget(
    this.date,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getoutfit(date),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(children: [
              GestureDetector(
                onTap: () {
                  // TODO 切頁至衣服介面(帶時間過去)  點擊衣櫃的圖片後 執行savecloth方法 然後pop回來
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) {
                  //   return 衣服介面(date);
                  // }));

                  // savecloth(OutfitModel(
                  //     poster: user!.uid,
                  //     date: '2022-02-17',
                  //     clothes:
                  //         'https://firebasestorage.googleapis.com/v0/b/clothing-f7788.appspot.com/o/posts%2Fpngfind.com-aesthetic-png-tumblr-1976459.png?alt=media&token=658b45c9-b918-4677-a404-7adaa8f05b26',
                  //     pants: ''));

                  //  Navigator.of(context).pop();
                },
                child: const Text('點擊新增衣服',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)), // add this
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                  onTap: () {
                    // TODO 切頁至褲子介面(帶時間過去)  點擊衣櫃的圖片後 執行savecloth方法 然後pop回來
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context) {
                    //   return 褲子介面(date);
                    // }));

                    // savepant(OutfitModel(poster: user!.uid, date: date, clothes: 褲子的網址, pants: ''));

                    //  Navigator.of(context).pop();
                  },
                  child: const Text('點擊新增褲子',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0))),
            ]);
          }

          final outfits_data = snapshot.requireData;
          return Column(
            children: [
              if (snapshot.requireData.docs[0]['clothes'] == '') ...[
                GestureDetector(
                    onTap: () {
                      // TODO 切頁至衣服介面(帶時間過去)  點擊衣櫃的圖片後 執行savecloth方法 然後pop回來
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return 衣服介面(date);
                      // }));

                      // savecloth(OutfitModel(poster: user!.uid, date: date, clothes: 衣服的網址, pants: ''));

                      //  Navigator.of(context).pop();
                    },
                    child: const Text('點擊新增衣服',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)) // add this
                    )
              ] else ...[
                GestureDetector(
                    onTap: () {
                      // TODO 切頁至衣服介面(帶時間過去)  點擊衣櫃的圖片後 執行savecloth方法 然後pop回來
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return 衣服介面(date);
                      // }));

                      // savecloth(OutfitModel(poster: user!.uid, date: date, clothes: 衣服的網址, pants: ''));

                      //  Navigator.of(context).pop();
                    },
                    child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    outfits_data.docs[0]['clothes'])))))
              ],
              const SizedBox(
                height: 10,
              ),
              if (snapshot.requireData.docs[0]['pants'] == '') ...[
                GestureDetector(
                    onTap: () {
                      // TODO 1.切頁至褲子介面(帶時間過去) 2.點擊衣櫃的圖片後  3.執行savecloth方法 4.然後pop回來
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return 褲子介面(date);
                      // }));

                      // savepant(OutfitModel(poster: user!.uid, date: date, clothes: 褲子的網址, pants: ''));

                      //  Navigator.of(context).pop();
                    },
                    child: const Text('點擊新增褲子',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0))),
              ] else ...[
                GestureDetector(
                    onTap: () {
                      // TODO 切頁至褲子介面(帶時間過去)  點擊衣櫃的圖片後 執行savecloth方法 然後pop回來
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return 褲子介面(date);
                      // }));

                      // savepant(OutfitModel(poster: user!.uid, date: date, clothes: 褲子的網址, pants: ''));

                      //  Navigator.of(context).pop();
                    },
                    child: Container(
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    outfits_data.docs[0]['pants'])))))
              ]
            ],
          );
        });
  }
}
//取得套裝
