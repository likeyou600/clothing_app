import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart ' as p ;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(upload());
}

class upload extends StatefulWidget {
  const upload({Key? key}) : super(key: key);

  @override
  _uploadState createState() => _uploadState();
}

class _uploadState extends State<upload> {
  final ImagePicker image = ImagePicker();
  String? imageUrl;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            elevation: 5.0,
            height: 60,
            onPressed: () {
              getImage();
            },
            child: Text(
              "  Get image",
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
            ),
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  getImage() async {
    final pickimg = await image.pickImage(source: ImageSource.gallery);
    if (pickimg != null) {
        var file = await ImageCropper.cropImage(sourcePath: pickimg.path,aspectRatio: CropAspectRatio(ratioX:1,ratioY:1));
        file = await compressImage(file!.path,35);

        await _uploadFile(file.path);
    }

  }

  Future<File> compressImage(String path,int quality) async{
    final newPath = p.join((await getTemporaryDirectory()).path,'${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,quality:quality);
    return result!;
  }

  Future _uploadFile(String path) async{
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('image')
        .child('${DateTime.now().toIso8601String()+p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl=fileUrl;
    });
  }



}

