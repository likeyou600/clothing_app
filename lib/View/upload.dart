import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:clothing_app/Controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:clothing_app/main.dart';

import '../Controller/PostImageController.dart';

class upload extends StatefulWidget {
  @override
  State<upload> createState() => _uploadState();
}

class _uploadState extends State<upload> {
  final TextEditingController _descriptionController = TextEditingController();

  List<AssetEntity> assets = <AssetEntity>[];
  Future<void> selectAssets() async {
    final result = await AssetPicker.pickAssets(context,
        maxAssets: 4,
        pathThumbSize: 84,
        gridCount: 4,
        selectedAssets: assets,
        pickerTheme: ThemeData(
          primaryColor: Color.fromRGBO(174, 221, 239, 1),
          accentColor: Color.fromRGBO(232, 215, 199, 1),
          canvasColor: Color.fromRGBO(232, 215, 199, 1),
        ),
        requestType: RequestType.common);
    if (result != null) {
      setState(() {
        assets = List<AssetEntity>.from(result);
      });
    }
  }

  Widget imageWidget(int index) {
    return GestureDetector(
        onTap: () async {
          AssetEntity? asset = assets[index];
          File? files = await asset.file;
          log(assets.toString());
          File? output = await ImageCropper.cropImage(
              sourcePath: files!.path,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
              androidUiSettings: const AndroidUiSettings(
                  toolbarTitle: '裁切工具',
                  toolbarColor: Color.fromRGBO(174, 221, 239, 1),
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              iosUiSettings: const IOSUiSettings(
                minimumAspectRatio: 1.0,
              ));
          final Uint8List byteData = await output!.readAsBytes();
          final AssetEntity? imageEntity =
              await PhotoManager.editor.saveImage(byteData);
          Fluttertoast.showToast(
              msg: "裁切完成，請按上方+號，重新選擇圖片",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image(
                image: AssetEntityImageProvider(
              assets.elementAt(index),
              isOriginal: true,
            ))));
  }

  @override
  Widget build(BuildContext context) {
    // selectAssets();
    log(assets.isNotEmpty.toString());
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 215, 199, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(174, 221, 239, 1),
          title: Text('新增貼文'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                selectAssets();
              },
            ),
            if (assets.isNotEmpty == true) ...[
              TextButton(
                onPressed: () => [
                  savepictodb(_descriptionController.text, assets),
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
            ]
          ]),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          if (assets.isNotEmpty == false) ...[
            const Center(
                child: Text('請按右上角+號 來新增貼文',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)))
          ],
          if (assets.isNotEmpty == true) ...[
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
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ],
          Container(
            width: MediaQuery.of(context).size.width,
            height: assets.isNotEmpty ? 250.0 : 0.0,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: assets.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Stack(
                      children: <Widget>[
                        imageWidget(index),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
