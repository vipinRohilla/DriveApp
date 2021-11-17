// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/api/firebase_api.dart';
import 'package:loginlogoutflutter/pages/image_pages.dart';
import 'package:loginlogoutflutter/screens/upload_screen.dart';
import 'package:loginlogoutflutter/screens/welcome_screen.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatefulWidget {
//   const GalleryScreen({Key? key}) : super(key: key);

//   @override
//   _GalleryScreenState createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {

  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}
final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user!.uid;

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseApi>(context);
    String? _url;
    dynamic _snapShotOfFile;

    

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
        // leading: const Text(""),
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
          ),
          GestureDetector(

            onTap: (){
               firebaseProvider.showMyDialog(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child:  Icon(Icons.create_new_folder),
            ),
          )
        ],
        title: const Text("Gallery Screen"),
      ),
      body: 

          Container(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore.collection(uid).snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? const Center(
                        child: Text("There is some problem loading your image"),
                      )
                    : snapshot.hasData
                        ? ListView(
                            children: snapshot.data!.docs.map((e) {
                              return GestureDetector(
                                onTap: (){
                                   Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => ImagePage(myUrl: e.get("url"))
                                          ));
                                },
                                child: ListTile(
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
                                  trailing: PopupMenuButton(
                                    onSelected: (String value){
                                        _url = e.get("url");
                                        _snapShotOfFile = snapshot;
                                        firebaseProvider.handleClick(value, _url!, context, _snapShotOfFile);
                                    },
                                    itemBuilder: (context){
                                      return {"Rename", "delete"}.map((e){
                                        return PopupMenuItem(child: Text(e), value: e,);
                                      }).toList();
                                    })
                              ));
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
    Future getFileType(file)
  {

    return file.stat();
  }
  }



