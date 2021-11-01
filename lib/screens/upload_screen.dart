import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginlogoutflutter/screens/gallery_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loginlogoutflutter/screens/welcome_screen.dart';
import 'package:path/path.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  List<UploadTask> uploadedTasks = [];
  List<File> selectedFiles = [];
  UploadTask? _task;
  File? _filePath;
  final ImagePicker _image = ImagePicker();

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
            () => print("${imageUrl} is saved"));
  }

  saveImageUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapshot) {
      if (snapshot.state == TaskState.success) {
        snapshot.ref.getDownloadURL().then((imageUrl) {
          print("4021" + snapshot.ref.name);
          String fileName = snapshot.ref.name;
          writeImageUrlToFireStore(imageUrl, fileName);
        });
        snapshot.ref.name;
        print(" 4020 my task is completed");
      }
    });
  }

  Future selectFileToUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (result != null) {
        final path = result.files.single.path!;

        selectedFiles.clear();
        for (var selectedFile in result.files) {
          final file = File(selectedFile.path!);
          selectedFiles.add(file);
        }

        for (var file in selectedFiles) {
          final UploadTask task = uploadFileToStorage(file);
          saveImageUrlToFirebase(task);

          setState(() {
            _filePath = File(path);
            uploadedTasks.add(task);
          });
        }
      } else {
        print("user cancelled the selection");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _filePath != null ? basename(_filePath!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        title: const Text("Upload Files"),
        //  leading: const Text(""),
        actions: [
          GestureDetector(
            onTap: () async {
              // await _auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Welcome()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                "Log out",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GalleryScreen()));
              },
              icon: const Icon(Icons.photo))
        ],

        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const GalleryScreen()));
        //       },
        //       icon: const Icon(Icons.photo))
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectFileToUpload();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              selectFileToUpload();
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Colors.blue.shade400,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Iconsax.folder_open,
                          color: Colors.blue,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Select your file',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          // Container(
          //     constraints: BoxConstraints(
          //         maxWidth: MediaQuery.of(context).size.width / 2),
          //     child: ElevatedButton(
          //       onPressed: () {
          //         uploadFile(context);
          //       },
          //       child: const Text("Upload", textAlign: TextAlign.center),
          //     )),
          Expanded(
            child: SizedBox(
              height: 600,
              child: uploadedTasks.isEmpty
                  ? const Center(child: Text(""))
                  : ListView.separated(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return StreamBuilder<TaskSnapshot>(
                          builder: (context, snapShot) {
                            return
                                // snapShot.connectionState == ConnectionState.waiting
                                //     ? const Center(child: CircularProgressIndicator())
                                //     :
                                snapShot.hasError
                                    ? const Text("Error Occured")
                                    : snapShot.hasData
                                        ? ListTile(
                                            dense: true,
                                            // isThreeLine: true,
                                            // children: [
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image(
                                                image: _filePath == null
                                                    ? const AssetImage(" ")
                                                    : FileImage(File(
                                                            _filePath!.path))
                                                        as ImageProvider,
                                                width: 70,
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   width: 10,
                                            // ),
                                            title: Text(fileName,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black)),

                                            subtitle: Text(
                                                "${snapShot.data?.bytesTransferred} /${snapShot.data?.totalBytes} ${snapShot.data?.state == TaskState.success ? "Completed" : snapShot.data?.state == TaskState.running ? "In Progress" : ""}"),

                                            // ]
                                          )
                                        : Container();
                          },
                          stream: uploadedTasks[index].snapshotEvents,
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            // final percentage = (progress * 100).toStringAsFixed(1);
            final _percentage = (progress * 100).toStringAsFixed(1);

            return Text(
              '$_percentage %',
              style: const TextStyle(fontSize: 12),
            );
          } else {
            return const Text("0.0 %");
          }
        },
      );
}
