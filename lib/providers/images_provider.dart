import 'dart:collection';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImagesProvider extends ChangeNotifier {
  final FilePicker _filePicker;
  final FirebaseStorage _storage;

  ImagesProvider(this._filePicker, this._storage);

  var _imagesFiles = HashMap<int, PlatformFile>();
  var taskStates = HashMap<int, TaskState>();
  HashMap<int, String> _images = HashMap<int, String>();
  HashMap<int, String> get images => _images;
  HashMap<int, PlatformFile> get imagesFiles => _imagesFiles;

  void updateState(int index, TaskState state) {
    taskStates[index] = state;
    notifyListeners();
  }

  void setImageUrl(int index, String url) {
    _images[index] = url;
    notifyListeners();
  }

  void emptyLists() {
    _imagesFiles.clear();
    _images.clear();
    taskStates.clear();
    notifyListeners();
  }

  Future<void> pickImage({@required int index}) async {
    if (taskStates[index] == TaskState.running)
      return await Fluttertoast.showToast(
        msg: 'uploading image in progress please wait...',
        backgroundColor: Colors.black45,
      );
    final result = await _filePicker.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (result == null)
      return await Fluttertoast.showToast(msg: 'no images picked');
    final imageFile = result.files.single;
    _imagesFiles[index] = imageFile;
    notifyListeners();
  }

  Stream<TaskSnapshot> uploadImage({
    @required String category,
    @required String dishId,
    @required int index,
  }) async* {
    final image = imagesFiles[index];

    final task = _storage
        .ref()
        .child(category)
        .child(dishId)
        .child(image.name)
        .putData(image.bytes);
    task.whenComplete(() async =>
        setImageUrl(index, await task.snapshot.ref.getDownloadURL()));
    yield* task.snapshotEvents;
  }
}
