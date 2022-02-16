import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart ' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:clothing_app/main.dart';

final ImagePicker image = ImagePicker();
String? imageUrl;
final users = FirebaseFirestore.instance.collection('users');

//pickImage搜尋圖片
getuserImage() async {
  final pickimg = await image.pickImage(source: ImageSource.gallery);
  if (pickimg != null) {
    var file = await ImageCropper.cropImage(
        sourcePath: pickimg.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    file = await compressImage(file!.path, 90);

    await _uploaduserFile(file.path);
  }
}
//上傳畫質調整
Future<File> compressImage(String path, int quality) async {
  final newPath = p.join((await getTemporaryDirectory()).path,
      '${DateTime.now()}.${p.extension(path)}');

  final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
      quality: quality);
  return result!;
}
//貼文存至db
Future _uploaduserFile(String path) async {
  final ref = FirebaseStorage.instance
      .ref()
      .child('userpic')
      .child('${DateTime.now().toIso8601String() + p.basename(path)}');

  final result = await ref.putFile(File(path));
  final fileUrl = await result.ref.getDownloadURL();
  DocumentSnapshot doc = await users.doc(user!.uid).get();
  await users.doc(user!.uid).update({'userpic': fileUrl});
}
