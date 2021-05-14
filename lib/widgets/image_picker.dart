import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';

import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

class ImagePicker extends StatelessWidget {
  final bool forEdit;
  final List<String>? dishImages;
  const ImagePicker({
    Key? key,
    required this.forEdit,
    this.dishImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ImageUploader(
            index: 0,
            forEdit: forEdit,
            dishImages: dishImages,
          ),
          ImageUploader(
            index: 1,
            forEdit: forEdit,
            dishImages: dishImages,
          ),
          ImageUploader(
            index: 2,
            forEdit: forEdit,
            dishImages: dishImages,
          ),
        ],
      ),
    );
  }
}

class ImageUploader extends StatefulWidget {
  final int index;
  final bool forEdit;
  final List<String>? dishImages;

  const ImageUploader({
    Key? key,
    required this.index,
    required this.forEdit,
    this.dishImages,
  }) : super(key: key);
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  late StreamController<TaskSnapshot> _streamController;
  StreamSubscription<TaskSnapshot>? _uploadSubscription;
  @override
  void initState() {
    _streamController = StreamController();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _uploadSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final picker = context.watch<ImagesProvider>();
    final addDishProvider = context.watch<AddDishProvider>();
    final isImageToUpload = picker.imagesFiles.containsKey(widget.index);
    final imagesMap = widget.dishImages?.asMap();
    final isImageFromDish = imagesMap?.containsKey(widget.index) ?? false;
    Widget _image() {
      return Positioned.fill(
        child: (isImageToUpload)
            ? Image.memory(
                picker.imagesFiles[widget.index]!.bytes!,
                fit: BoxFit.cover,
              )
            : (widget.forEdit && isImageFromDish)
            ? Image.network(
                corsBridge + imagesMap![widget.index]!,
                fit: BoxFit.cover,
              )
            : const Icon(
                Icons.photo,
                color: Colors.white,
              ),
      );
    }

    return StreamBuilder<TaskSnapshot>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          final taskSnapshot = snapshot.data;
          return Container(
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
                      _image(),
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
                      icon: const Icon(Icons.photo_library, color: Colors.teal),
                      tooltip: 'Pick Image',
                      onPressed: () async =>
                          await picker.pickImage(widget.index),
                    ),
                    if (picker.imagesFiles[widget.index] != null)
                      IconButton(
                          onPressed: () =>
                              picker.imagesFiles.remove(widget.index),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    IconButton(
                        icon: const Icon(
                          Icons.cloud_upload,
                          color: Colors.green,
                        ),
                        tooltip: 'upload image',
                        onPressed: () {
                          if (addDishProvider.dishCategories.first.isNotEmpty) {
                            final uploadTask = picker.uploadImage(
                              category: addDishProvider.dishCategories.first,
                              dishId: addDishProvider.getDishId!,
                              index: widget.index,
                            );
                            _uploadSubscription =
                                uploadTask.listen(_streamController.add);
                          }
                        }),
                    if (taskSnapshot != null &&
                        taskSnapshot.state == TaskState.running)
                      const Center(child: const GFLoader()),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
