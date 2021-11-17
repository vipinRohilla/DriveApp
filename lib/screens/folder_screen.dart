import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';
import 'package:path_provider/path_provider.dart';

import 'detail_folder.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> createFolderInAppDocDir(String folderName) async {


    final Directory _appDocDir = await getApplicationDocumentsDirectory();

    final Directory _appDocDirFolder =
    Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {

      return _appDocDirFolder.path;
    } else {

      final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  callFolderCreationMethod(String folderInAppDocDir) async {
    // ignore: unused_local_variable
    String actualFileName = await createFolderInAppDocDir(folderInAppDocDir);
    // print("my1234" + actualFileName);
    setState(() {});
  }

  final folderController = TextEditingController();
  dynamic nameOfFolder;
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
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
                  setState(() {
                    nameOfFolder = folderController.text;
                    FirebaseFolderName.setFileName(nameOfFolder);
                    // setFileName;
                    // print(nameOfFolder);
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              style : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (nameOfFolder != null) {
                  await callFolderCreationMethod(nameOfFolder);
                  getDir();
                  setState(() {
                    folderController.clear();
                    nameOfFolder = null;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            ElevatedButton(
              style : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent)
              ),
              // color: Colors.redAccent,
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

  late List<FileSystemEntity> _folders;
  Future<void> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    // print(_folders);
  }

  Future<void> _showDeleteDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure to delete this folder?',
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () async {
                await _folders[index].delete();
                getDir();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _folders=[];
    getDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drive App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () {
              _showMyDialog();
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Material(
            elevation: 1.0,
            // shape: ShapeBorder. ,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      FutureBuilder(
                          future: getFileType(_folders[index]),
                          builder: (ctx,snapshot){

                            if(snapshot.hasData)
                              {
                                FileStat? f=snapshot.data as FileStat?;
                                // print("file status 123:() ${f!.type}");
                                if(f!.type.toString().contains("file"))
                                  {
                                  return  const Icon(
                                      Icons.file_copy_outlined,
                                      size: 25,
                                      color: Colors.orange,
                                    );
                                  }else
                                    {
                                      return  InkWell(
                                        onTap: (){
                                          // print("this is path 1234"+_folders[index].path);
                                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                                            return InnerFolder(filespath:_folders[index].path);
                                          }));
                                        },
                                        child: const Icon(
                                          Icons.folder,
                                          size: 50,
                                          color: Colors.orangeAccent
                                        ),
                                      );
                                    }
                              }
                        return const Icon(
                          Icons.file_copy_outlined,
                          size: 100,
                          color: Colors.orange,
                        );
                      }),

                      Text(
                        _folders[index].path.split('/').last,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _showDeleteDialog(index);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: _folders.length,
      ),
    );
  }

  Future getFileType(file)
  {

    return file.stat();
  }

}