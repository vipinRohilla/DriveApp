
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:loginlogoutflutter/api/firebase_api.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/screens/welcome_screen.dart';
import 'package:loginlogoutflutter/widgets/button_widget.dart';

import '../main.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UploadTask? task;
  File? file;
  ImagePicker image = ImagePicker();
  final _auth = FirebaseAuth.instance;
  String alreadyUploaded = "";

  late Future<List<FirebaseFile>> futureFiles;
  @override
  void initState(){
    super.initState();
    futureFiles = FirebaseApi.listAll('files/');

  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        leading: 
        GestureDetector(child:
            const Icon(Icons.arrow_back_ios_new_rounded)
          ,onTap: (){
            Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (a,b,c)=> const MyApp(),
          transitionDuration: const Duration(seconds: 0))
          );
          },
        ),

        elevation: 0,
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
      body: homeScreenPage(context, fileName),
    );
  }


  Widget homeScreenPage(BuildContext context, String fileName){
  return Scaffold(
    // backgroundColor: Colors.blue.shade50,
      body: Column(

        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(fileName),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          ButtonWidget(icon: Icons.attach_file, text: "Select File", onClicked: selectFile),
          ButtonWidget(icon: Icons.upload, text: "Upload File", onClicked: uploadFile),
        ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(alreadyUploaded),
        ),
        task != null ? 
        buildUploadStatus(task!) 
        : Container(),
        const Divider(thickness: 1  ,),

        file == null 
        ? Container() 
          :
        Expanded(
          child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
                    children: [
                        Text("Preview", style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/45,
                        fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20,),
                        Container(
                            constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height/2,
                            ),
                          child: 
                            Image(image: file == null ? const AssetImage(" "): FileImage(File(file!.path)) as ImageProvider)
                          ),
                        ],
                      ),
                    ),
                  ),
        ]
      ),
  );
}




Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

}

Future uploadFile() async{

  if(file == null){
    return ;
  }

  var fileName = basename(file!.path);
  final destination = 'files/$fileName';
  task = FirebaseApi.uploadFile(destination, file!);
  setState(() {
  });

  if(task == null) return;
}

Widget uploadProgressBar(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            var _percentage = double.parse(percentage)/100;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 10,
                child: LinearProgressIndicator(
                  value: _percentage,
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                  backgroundColor: Colors.red,
                ),
              ),
            ) ;
          } else {
            return 
            Container()
            ;
          }
        },
  );
}
Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(1);

            return Text(
              '$percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );




