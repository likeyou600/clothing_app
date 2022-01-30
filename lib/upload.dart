import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart ' as p;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;

Future<void> main() async {
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              MaterialButton(
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
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/auth', (Route<dynamic> route) => false);
                    setState(() {});
                  },
                  child: Text('Log out'))
            ])),
      ),
    );
  }

  getImage() async {
    final pickimg = await image.pickImage(source: ImageSource.gallery);
    if (pickimg != null) {
      var file = await ImageCropper.cropImage(
          sourcePath: pickimg.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      file = await compressImage(file!.path, 35);

      await _uploadFile(file.path);
    }
  }

  Future<File> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);
    return result!;
  }

  Future _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('posts')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    CollectionReference postpics =
        FirebaseFirestore.instance.collection('postpics');

    var docRef = await posts.add({
      'poster': user!.uid,
      'content': 'test message',
      'publish_date ': DateTime.now(),
      'reported': false
    });

    var postid = docRef.id;
    postpics.add({
      'post_id': postid,
      'pic_url': fileUrl,
    });
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/post', (Route<dynamic> route) => false);
    setState(() {
      imageUrl = fileUrl;
    });
  }
}
