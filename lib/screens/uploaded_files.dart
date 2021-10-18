import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loginlogoutflutter/api/firebase_api.dart';
import 'package:loginlogoutflutter/main.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/pages/image_pages.dart';
import 'package:loginlogoutflutter/screens/home_screen.dart';
import 'package:loginlogoutflutter/screens/welcome_screen.dart';


class UploadedFiles extends StatefulWidget {
  const UploadedFiles({ Key? key }) : super(key: key);

  @override
  _UploadedFilesState createState() => _UploadedFilesState();
}

class _UploadedFilesState extends State<UploadedFiles> {

  UploadTask? task;
  File? file;

  final _auth = FirebaseAuth.instance;
  late Future<List<FirebaseFile>> futureFiles;
 
  @override
  void initState(){
    super.initState();
    futureFiles = FirebaseApi.listAll('files/');
  }

   

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        elevation: 2,
        actions: [
          GestureDetector(
            onTap: ()async{
          await _auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const  Welcome()));
        },
            child:  Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: Text("Log out", style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/26,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),)),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: (){
          Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (a,b,c)=> const MyApp(),
          transitionDuration: const Duration(seconds: 0))
          );
        // ignore: void_checks
        return Future.value(false);
        },
        child: FutureBuilder<List<FirebaseFile>>(
            
            future: futureFiles,
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator(),);
        
                default: 
                if(snapshot.hasError){
                  return const Center(child: Text("Sorry, some error occurred!"),);
                }
                else{
                final files = snapshot.data!;
                return Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(onPressed: (){
                                Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const HomeScreen()
                              
                              ),
                            );
                            }, 
                            child: Row(
                              children: const [
                                Icon(Icons.cloud_upload_outlined),
                                SizedBox(width: 10),
                                Text("Upload your files"),
                              ],
                            ),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),),
                          ),
                        ],
                      ),
                      const Divider(),
                      buildHeader(files.length, context),
                      const Divider(),
                       Text("Swipe down to refresh",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/70
                      ),
                      ),
                      
                      const SizedBox(height: 12,),
                      Expanded(child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index){
                          final file = files[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildTheFile(context, file),
                          );
                        },
                        ))
              ],
            );
                }
              }
            }
          ),
      ),
    );
  
  }



  Widget buildHeader(int length, BuildContext context) => ListTile(
        leading: SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: const Icon(
            Icons.file_copy,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$length Files',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            InkWell(
              child: const Icon(Icons.refresh),
              onTap:() {
                Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (a,b,c)=> const MyApp(),
          transitionDuration: const Duration(seconds: 0))
          );
              },
            )
          ],
        ),
        
);

 Widget buildTheFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipOval(
          child: Image.network(
            file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImagePage(file: file),
        )
        ),
      );
  }




