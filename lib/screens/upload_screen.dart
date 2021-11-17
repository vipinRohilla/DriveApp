import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loginlogoutflutter/api/firebase_api.dart';
import 'package:loginlogoutflutter/screens/gallery_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loginlogoutflutter/screens/welcome_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseApi>(context);
    final fileName = firebaseProvider.getFilePath != null
        ? basename(firebaseProvider.getFilePath!.path)
        : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        title: const Text("Upload Files"),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GalleryScreen()));
              },
              icon: const Icon(Icons.photo))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // selectFileToUpload();
          firebaseProvider.selectFileToUpload(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // selectFileToUpload();
              firebaseProvider.selectFileToUpload(context);
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
          Expanded(
            child: SizedBox(
              height: 600,
              child: firebaseProvider.getUploadedTasks.isEmpty
                  ? const Center(child: Text(""))
                  : ListView.separated(
                      itemCount: firebaseProvider.getUploadedTasks.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<TaskSnapshot>(
                          builder: (context, snapShot) {
                            return snapShot.hasError
                                ? const Text("Error Occured")
                                : snapShot.hasData
                                    ? ListTile(
                                        dense: true,
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image(
                                            image:
                                                firebaseProvider.getFilePath ==
                                                        null
                                                    ? const AssetImage(" ")
                                                    : FileImage(File(
                                                            firebaseProvider
                                                                .getFilePath!
                                                                .path))
                                                        as ImageProvider,
                                            width: 70,
                                          ),
                                        ),
                                        title: Text(fileName,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black)),
                                        subtitle: snapShot.data?.state ==
                                                TaskState.success
                                            ? const Text("Completed")
                                            : const LinearProgressIndicator(),
                                      )
                                    : Container();
                          },
                          stream: firebaseProvider
                              .getUploadedTasks[index].snapshotEvents,
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
}
