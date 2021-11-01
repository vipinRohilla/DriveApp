// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:loginlogoutflutter/api/firebase_api.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:loginlogoutflutter/model/firebase_model_file.dart';
// import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:loginlogoutflutter/screens/welcome_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

// import '../main.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   dynamic _percentage = 0.0;
//   UploadTask? _task;
//   File? _file;
//   final ImagePicker _image = ImagePicker();
//   final _auth = FirebaseAuth.instance;
//   String alreadyUploaded = "";
//   // late AnimationController loadingController;

//   late Future<List<FirebaseFile>> futureFiles;
//   @override
//   void initState() {
//     super.initState();
//     futureFiles = FirebaseApi.listAll('files/');
//   }

//   // getImage() async {
//   //   var img = await _image.pickImage(source: ImageSource.gallery);
//   //   setState(() {
//   //     _file = File(img!.path);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final fileName = _file != null ? basename(_file!.path) : 'No File Selected';
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurpleAccent.shade700,
//         leading: GestureDetector(
//           child: const Icon(Icons.arrow_back_ios_new_rounded),
//           onTap: () {
//             // notifierLis
//             Navigator.pushReplacement(
//                 context,
//                 PageRouteBuilder(
//                     pageBuilder: (a, b, c) => const MyApp(),
//                     transitionDuration: const Duration(seconds: 0)));
//           },
//         ),
//         elevation: 0,
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               await _auth.signOut();
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => const Welcome()));
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Center(
//                   child: Text(
//                 "Log out",
//                 style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width / 26,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white),
//               )),
//             ),
//           )
//         ],
//       ),
//       body: homeScreenPage(context, fileName),
//     );
//   }

//   Widget homeScreenPage(BuildContext context, String fileName) {
//     return Scaffold(
//       body: Column(children: [
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//           child: Text(fileName),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             GestureDetector(
//               onTap: selectFile,
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 40.0, vertical: 20.0),
//                   child: DottedBorder(
//                     borderType: BorderType.RRect,
//                     radius: const Radius.circular(10),
//                     dashPattern: const [10, 4],
//                     strokeCap: StrokeCap.round,
//                     color: Colors.blue.shade400,
//                     child: Container(
//                       width: double.infinity,
//                       height: 150,
//                       decoration: BoxDecoration(
//                           color: Colors.blue.shade50.withOpacity(.3),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Iconsax.folder_open,
//                             color: Colors.blue,
//                             size: 40,
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             'Select your file',
//                             style: TextStyle(
//                                 fontSize: 15, color: Colors.grey.shade400),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//             ),
//             Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width / 2),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     uploadFile(context);
//                   },
//                   child: const Text("Upload", textAlign: TextAlign.center),
//                 )),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(alreadyUploaded),
//         ),
//         const Divider(
//           thickness: 2,
//         ),
//         _file == null
//             ? Container()
//             : Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Preview",
//                       style: TextStyle(
//                           color: Colors.grey.shade400,
//                           fontSize: MediaQuery.of(context).size.height / 45,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade200,
//                                 offset: const Offset(0, 1),
//                                 blurRadius: 3,
//                                 spreadRadius: 2,
//                               )
//                             ]),
//                         constraints: BoxConstraints(
//                           maxHeight: MediaQuery.of(context).size.height / 2,
//                         ),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image(
//                                 image: _file == null
//                                     ? const AssetImage(" ")
//                                     : FileImage(File(_file!.path))
//                                         as ImageProvider,
//                                 width: 70,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             SizedBox(
//                                 height: 45,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(fileName,
//                                         style: const TextStyle(
//                                             fontSize: 13, color: Colors.black)),
//                                     const SizedBox(
//                                       height: 3,
//                                     ),
//                                     Container(
//                                       height: 24,
//                                       clipBehavior: Clip.hardEdge,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: _task != null
//                                           ? buildUploadStatus(_task!)
//                                           : Container(),
//                                     ),
//                                   ],
//                                 ))
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//       ]),
//     );
//   }

//   Future selectFile() async {
//     final result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: ['png', 'jpg', 'jpeg']);

//     if (result == null) return;
//     final path = result.files.single.path!;
//     setState(() {
//       _file = File(path);
//       _percentage = "0.0";
//     });
//     // loadingController.forward();
//   }

//   Future uploadFile(BuildContext context) async {
//     if (_file == null) {
//       return;
//     }

//     var fileName = basename(_file!.path);
//     // var uuid = const Uuid().v4();
//     final destination = 'files/$fileName';

//     // Provider.of<FirebaseApi>(context, listen: false)
//     //     .uploadFile(destination, _file!);
//     _task = FirebaseApi.uploadFile(destination, _file!);

//     setState(() {
//       print("12312" + _task.toString());
//     });

//     if (_task == null) return;
//   }

//   Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!;
//             final progress = snap.bytesTransferred / snap.totalBytes;
//             // final percentage = (progress * 100).toStringAsFixed(1);
//             _percentage = (progress * 100).toStringAsFixed(1);

//             return Text(
//               '$_percentage %',
//               style: const TextStyle(fontSize: 12),
//             );
//           } else {
//             return const Text("0.0 %");
//           }
//         },
//       );
// }
