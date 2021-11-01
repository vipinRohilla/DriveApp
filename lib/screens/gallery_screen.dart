import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/screens/upload_screen.dart';
import 'package:loginlogoutflutter/screens/welcome_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UploadScreen()),
            );
          },
          child: const Text("+  upload files")),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        leading: Text(""),
        elevation: 2,
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
          )
        ],
        title: const Text("Gallery Screen"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firebaseFirestore.collection("images").snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasError
                ? const Center(
                    child: Text("There is some problem loading your image"),
                  )
                : snapshot.hasData
                    ? ListView(
                        children: snapshot.data!.docs.map((e) {
                          // print(snapshot.hasData);
                          return ListTile(
                            leading: Image.network(
                              e.get("url"),
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              e.get("filename"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  deleteImage(e.get("url"), context);
                                },
                                child: const Icon(Icons.delete)),
                          );
                        }).toList(),
                      )
                    : const Center(
                        child: Text("No files"),
                      );
          },
        ),
      ),
    );
  }

  deleteImage(String imgUrl, BuildContext context) async {
    String url = imgUrl;
    Reference reference = FirebaseStorage.instance.refFromURL(url);
    reference.delete();
    setState(() {
      // print("delete");
    });
  }
}