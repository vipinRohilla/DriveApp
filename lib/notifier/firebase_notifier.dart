import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:loginlogoutflutter/model/firebase_model_file.dart';

class FireBaseNotifier with ChangeNotifier {
  List<FirebaseFile> _file = [];
  late FirebaseFile _currentFile;

  UnmodifiableListView<FirebaseFile> get file => UnmodifiableListView(_file);

  FirebaseFile get currentFile => _currentFile;

  set file(List<FirebaseFile> file) {
    _file = file;
    notifyListeners();
  }

  set currentFile(FirebaseFile file) {
    _currentFile = file;
    notifyListeners();
  }
}
