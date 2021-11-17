// import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:loginlogoutflutter/screens/gallery_screen.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;

class FirebaseApi with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final List<UploadTask> _uploadedTasks = [];
  final List<File> _selectedFiles = [];
  File? _filePath;

  List<UploadTask> get getUploadedTasks => _uploadedTasks;
  List<File> get getSelectedFiles => _selectedFiles;
  File? get getFilePath => _filePath;
  dynamic folderName;
  dynamic i= 0;

  uploadFileToStorage(File file, folderName) {

    // String folderName = FirebaseFolderName().getFileName!;
    UploadTask task = _firebaseStorage
        .ref()
        .child("$uid/$folderName/${DateTime.now().toString()}")
        .putFile(file);

    return task;
  }

  writeImageUrlToFireStore(imageUrl, fileName, folderName) {
    i++;
    _firebaseFirestore
        .collection(uid).doc(folderName).collection(uid).doc(folderName+i.toString())
        .set({"url": imageUrl, "filename": fileName}).whenComplete(
            () => {SnackBar(content: Text("$imageUrl is saved"))});
    // print("$imageUrl is saved");
    // print("This is my current Folder 12345 : "+folderName);
  }

  saveImageUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapshot) {
      if (snapshot.state == TaskState.success) {
        snapshot.ref.getDownloadURL().then((imageUrl) {
          // print("4021" + snapshot.ref.name);
          String fileName = snapshot.ref.name;
          writeImageUrlToFireStore(imageUrl, fileName, folderName);
        });
        snapshot.ref.name;
        // print(" 4020 my task is completed");
      }
    });
  }

  Future selectFileToUpload(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true);

      if (result != null) {
        final path = result.files.single.path!;

        _selectedFiles.clear();
        for (var selectedFile in result.files) {
          final file = File(selectedFile.path!);
          _selectedFiles.add(file);
        }
        UploadTask? task;
        folderName = FirebaseFolderName.getFileName!;
        // print("model folder 123456 : "+folderName);
        for (var file in _selectedFiles) {
          task = uploadFileToStorage(file, folderName);
          saveImageUrlToFirebase(task!);
          _filePath = File(path);
          _uploadedTasks.add(task);
          notifyListeners();
        }
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => GalleryScreen()));
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
        .collection(uid)
        .doc(snapshot.data?.docs[0].id)
        .delete();
    // .then((value) => print("delete"));

    notifyListeners();
  }

  Future updateData(uidd, newFileName) async{
    CollectionReference reference = FirebaseFirestore.instance.collection(uidd).doc(folderName).collection(uidd);
    return await reference.doc("myFolder2").update({
      "filename" : newFileName
    });
  }

  void handleClick(String value, String imgUrl, context, snapshot){
      switch (value) {
        case "Rename":
              // updateData(uidd, newFileName);
          break;
          case "delete":
          deleteImage(imgUrl, context, snapshot);
          break;
        default:
      }
  }

  final folderController = TextEditingController();
  dynamic nameOfFolder;

  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();

    //App Document Directory + folder name
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  callFolderCreationMethod(String folderInAppDocDir) async {
    // ignore: unused_local_variable
    String actualFileName = await createFolderInAppDocDir(folderInAppDocDir);
    // print(actualFileName);
    // setState(() {});
    notifyListeners();
  }

  

  

  Future<void> showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: const [
              Text(
                'ADD FOLDER',
                textAlign: TextAlign.left,
              ),
              Text(
                'Type a folder name to add',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: folderController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter folder name'),
                onChanged: (val) {
                  // setState(() {
                    nameOfFolder = folderController.text;
                    // print(nameOfFolder);
                    notifyListeners();
                  // });
                },
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (nameOfFolder != null) {
                  await callFolderCreationMethod(nameOfFolder);
                  // getDir();
                  // setState(() {
                    folderController.clear();
                    nameOfFolder = null;
                    notifyListeners();
                  // });
                  Navigator.of(context).pop();
                }
              },
            ),
            ElevatedButton(
              // : Colors.redAccent,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  

  
  





  
}
