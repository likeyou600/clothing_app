import 'dart:developer';
import 'dart:io';
import 'package:clothing_app/Controller/PostController.dart';
import 'package:clothing_app/Model/PostModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart ' as p;
import 'package:firebase_storage/firebase_storage.dart';

final ImagePicker image = ImagePicker();
String? imageUrl;

getImage() async {
  final pickimg = await image.pickImage(source: ImageSource.gallery);
  if (pickimg != null) {
    var file = await ImageCropper.cropImage(
        sourcePath: pickimg.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    file = await compressImage(file!.path, 90);

    final url = await _uploadFile(file.path);

    return url;
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
  final ref = FirebaseStorage.instance
      .ref()
      .child('posts')
      .child('${DateTime.now().toIso8601String() + p.basename(path)}');

  final result = await ref.putFile(File(path));
  final fileUrl = await result.ref.getDownloadURL();
  return fileUrl;
}

Future savepictodb(String comment, String url) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  createPost(PostModel(
      poster: user!.uid,
      content: comment,
      publish_time: DateTime.now(),
      reported: false,
      postpics: [url],
      collections: [],
      likes: []));
}
