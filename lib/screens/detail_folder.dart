// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/api/firebase_api.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';
import 'package:loginlogoutflutter/pages/image_pages.dart';
import 'package:loginlogoutflutter/screens/upload_screen.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
class InnerFolder extends StatefulWidget{

  // ignore: use_key_in_widget_constructors
  const InnerFolder({required this.filespath});
  final String filespath;

  @override
  State<StatefulWidget> createState() {
    return InnerFolderState();
  }

}
class InnerFolderState extends State<InnerFolder>{

  dynamic uidd;

  String get fileStr => widget.filespath;
  dynamic tempo;
  

  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uidd = user!.uid;
    List<String> temp = fileStr.split("/");
    tempo = temp[temp.length-1];
    // print("path 1234 path "+tempo);
    FirebaseFolderName.fileName = tempo;
    // print("current folder name 1111 : " + FirebaseFolderName.getFileName.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    // final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
final firebaseProvider = Provider.of<FirebaseApi>(context);
    String? _url;
    dynamic _snapShotOfFile;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child : const Icon(Icons.add),
        onPressed: (){
              // print(ModalRoute.of(context)?.settings.name);
              Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const UploadScreen()),
                      );
              
      },),
      appBar: AppBar(
        title: Text(tempo),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              // _showMyDialog();
              Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const UploadScreen()),
                      );
            },
          ),
        ],
      ),
      body: Container(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore.collection(uidd).doc(tempo).collection(uidd).snapshots(),
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
      
      
      
      
      
      
      
      // GridView.builder(
      //   padding: const EdgeInsets.symmetric(
      //     horizontal: 10,
      //     vertical: 15,
      //   ),
      //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //     maxCrossAxisExtent: 180,
      //     mainAxisSpacing: 10,
      //     crossAxisSpacing: 10,
      //   ),
      //   itemBuilder: (context, index) {
      //     return Material(
      //       // elevation: 6.0,
      //       child: Stack(
      //         children: [
      //           Container(
      //             width: double.infinity,
      //             padding: const EdgeInsets.all(5),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [

      //                 FutureBuilder(
      //                     future: getFileType(_folders[index]),
      //                     builder: (ctx,snapshot){

      //                       if(snapshot.hasData)
      //                       {
      //                         FileStat? f=snapshot.data as FileStat?;
      //                         print("file.stat() ${f!.type}");
      //                         ;
      //                         if(f.type.toString().contains("file"))
      //                         {
      //                           return  const Icon(
      //                             Icons.file_copy_outlined,
      //                             size: 100,
      //                             color: Colors.orange,
      //                           );
      //                         }else
      //                         {
      //                           return  InkWell(
      //                             onTap: (){
      //                               final myDir = Directory(_folders[index].path);

      //                               var _folders_list = myDir.listSync(recursive: true, followLinks: false);

      //                               for(int k=0;k<_folders_list.length;k++)
      //                               {
      //                                 var config = File(_folders_list[k].path);
      //                                 print("IsFile ${config is File}");
      //                               }
      //                               print(_folders_list);
      //                             },
      //                             child: const Icon(
      //                               Icons.folder,
      //                               size: 100,
      //                               color: Colors.orange,
      //                             ),
      //                           );
      //                         }
      //                       }
      //                       return const Icon(
      //                         Icons.file_copy_outlined,
      //                         size: 100,
      //                         color: Colors.orange,
      //                       );
      //                     }),

      //                 Text(
      //                   _folders[index].path.split('/').last,
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Positioned(
      //             top: 10,
      //             right: 10,
      //             child: GestureDetector(
      //               onTap: () {
      //                 _showDeleteDialog(index);
      //               },
      //               child: const Icon(
      //                 Icons.delete,
      //                 color: Colors.grey,
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     );
      //   },
      //   itemCount: _folders.length,
      // ),
    );
  }
  Future getFileType(file)
  {

    return file.stat();
  }
}