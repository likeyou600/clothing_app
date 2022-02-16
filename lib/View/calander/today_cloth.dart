import 'package:clothing_app/Controller/OutfitController.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class today_cloth extends StatefulWidget {
  DateTime selectday;
  today_cloth(this.selectday);
  @override
  State<today_cloth> createState() => _today_clothState();
}

class _today_clothState extends State<today_cloth> {
  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy-MM-dd').format(widget.selectday);

    return MaterialApp(
        home: Container(
            child: Scaffold(
                backgroundColor: Color.fromRGBO(232, 215, 199, 1),
                appBar: AppBar(
                    backgroundColor: Color.fromRGBO(174, 221, 239, 1),
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    title: Text(
                        //  – kk:mm
                        date + "  穿搭")),
                body: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: outfitWidget(date))))));
  }
}
