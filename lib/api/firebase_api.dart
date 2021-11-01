import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi with ChangeNotifier {
  // Future<
  static UploadTask?
      // >
      uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final imgUrl = ref.getDownloadURL();
      // print("4020" + imgUrl.toString());

      final temp = ref.putFile(file);
      print("4021" + temp.toString());
      // temp.state
      return temp;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final _ref = FirebaseStorage.instance.ref(path);
    final _result = await _ref.listAll();

    final urls = await _getDownloadLinks(_result.items);

    return urls
        .asMap()
        .map((index, url) {
          final _ref = _result.items[index];
          final _name = _ref.name;
          final _file = FirebaseFile(ref: _ref, name: _name, url: url);

          return MapEntry(index, _file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }
}
