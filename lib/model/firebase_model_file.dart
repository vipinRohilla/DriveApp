class FirebaseFile {
  String? _url;
  String? _fileName;

  String? get getUrl => _url;
  String? get getFileName => _fileName;

  setUrl(String myUrl) {
    _url = myUrl;
  }

  setFileName(String myFileName) {
    _fileName = myFileName;
  }

  FirebaseFile(this._url, this._fileName);
}
