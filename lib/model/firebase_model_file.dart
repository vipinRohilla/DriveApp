import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  // String id;
  Reference ref;
  String name;
  String url;

  FirebaseFile({
    // required this.id,
    required this.ref,
    required this.name,
    required this.url,
  });

  // FirebaseFile.fromMap(
  //     Map<String, dynamic> data, this.ref, this.name, this.url, this.id) {
  //   id = data["id"];
  //   ref = data["ref"];
  //   name = data["name"];
  //   url = data["url"];
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id' : id,
  //     'ref' : ref,
  //     'name' : name,
  //     'url' : url
  //   };
  // }
}
