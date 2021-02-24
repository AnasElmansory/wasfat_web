import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

class ImagePicker extends StatelessWidget {
  final String category;
  final String dishId;
  const ImagePicker({Key key, this.category, this.dishId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          const ImageUploader(index: 0),
          const ImageUploader(index: 1),
          const ImageUploader(index: 2),
        ],
      ),
    );
  }
}

class ImageUploader extends StatefulWidget {
  final String category;
  final String dishId;
  final int index;

  const ImageUploader({Key key, this.category, this.dishId, this.index})
      : super(key: key);
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  StreamController<TaskSnapshot> _streamController;
  StreamSubscription<TaskSnapshot> _uploadSubscription;
  @override
  void initState() {
    _streamController = StreamController();
    super.initState();
  }

  @override
  void dispose() {
    _streamController?.close();
    _uploadSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final picker = context.watch<ImagesProvider>();
    return StreamBuilder<TaskSnapshot>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          final taskSnapshot = snapshot.data;
          return InkWell(
            onTap: () {
              print(taskSnapshot.bytesTransferred);
              print(taskSnapshot.state);
              print(taskSnapshot.totalBytes);
            },
            child: Container(
              height: size.height * 0.4,
              width: size.width * 0.2,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.3,
                    width: size.width * 0.3,
                    color: Colors.black45,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: (picker.imagesFiles.containsKey(widget.index))
                              ? Image(
                                  image: MemoryImage(
                                      picker.imagesFiles[widget.index].bytes),
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                        ),
                        if (taskSnapshot != null &&
                            taskSnapshot.state == TaskState.success)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black45,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.photo_library, color: Colors.teal),
                        tooltip: 'pick image',
                        onPressed: () async =>
                            await picker.pickImage(index: widget.index),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.cloud_upload,
                            color: Colors.green,
                          ),
                          tooltip: 'upload image',
                          onPressed: () {
                            final uploadTask = picker.uploadImage(
                              category: widget.category,
                              dishId: widget.dishId,
                              index: widget.index,
                            );
                            _uploadSubscription =
                                uploadTask.listen(_streamController.add);
                          }),
                      if (taskSnapshot != null &&
                          taskSnapshot.state == TaskState.running)
                        Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.amber[700],
                            value: (taskSnapshot.bytesTransferred /
                                    taskSnapshot.totalBytes)
                                .toDouble(),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
