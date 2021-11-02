import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseApi with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final List<UploadTask> _uploadedTasks = [];
  final List<File> _selectedFiles = [];
  File? _filePath;

  List<UploadTask> get getUploadedTasks => _uploadedTasks;
  List<File> get getSelectedFiles => _selectedFiles;
  File? get getFilePath => _filePath;

  uploadFileToStorage(File file) {
    UploadTask task = _firebaseStorage
        .ref()
        .child("image/${DateTime.now().toString()}")
        .putFile(file);

    return task;
  }

  writeImageUrlToFireStore(imageUrl, fileName) {
    _firebaseFirestore
        .collection("images")
        .add({"url": imageUrl, "filename": fileName}).whenComplete(
            () => {SnackBar(content: Text("$imageUrl is saved"))});
    // print("$imageUrl is saved");
  }

  saveImageUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapshot) {
      if (snapshot.state == TaskState.success) {
        snapshot.ref.getDownloadURL().then((imageUrl) {
          // print("4021" + snapshot.ref.name);
          String fileName = snapshot.ref.name;
          writeImageUrlToFireStore(imageUrl, fileName);
        });
        snapshot.ref.name;
        // print(" 4020 my task is completed");
      }
    });
  }

  Future selectFileToUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (result != null) {
        final path = result.files.single.path!;

        _selectedFiles.clear();
        for (var selectedFile in result.files) {
          final file = File(selectedFile.path!);
          _selectedFiles.add(file);
        }

        for (var file in _selectedFiles) {
          final UploadTask task = uploadFileToStorage(file);
          saveImageUrlToFirebase(task);
          _filePath = File(path);
          _uploadedTasks.add(task);

          notifyListeners();
        }
      } else {
        // print("user cancelled the selection");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future deleteImage(String imgUrl, BuildContext context, snapshot) async {
    Reference reference = FirebaseStorage.instance.refFromURL(imgUrl);
    reference.delete();
    _firebaseFirestore
        .collection("images")
        .doc(snapshot.data?.docs[0].id)
        .delete();
    // .then((value) => print("delete"));

    notifyListeners();
  }
}
