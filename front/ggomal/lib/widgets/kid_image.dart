import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KidImage extends StatefulWidget {
  const KidImage({super.key});

  @override
  State<KidImage> createState() => _KidImageState();
}

class _KidImageState extends State<KidImage> {
  final ImagePicker picker = ImagePicker();
  XFile? _imageFile;

  Future<void> getImage(ImageSource imageSource) async {
    try {
      final XFile? imageFile = await picker.pickImage(
          source: imageSource, maxHeight: 300, maxWidth: 300);
      if (imageFile != null) {
        setState(() {
          _imageFile = imageFile;
        });
      }
    } catch (e) {
      print("$e");
    }
  }

  Widget kidPhoto() {
    return _imageFile != null
        ? Image.file(File(_imageFile!.path), fit: BoxFit.cover)
        : Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text("사진을 촬영하거나\n등록해 주세요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NanumS',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  )),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey[100],
              width: 150,
              height: 150,
              child: kidPhoto(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            )
          ],
        ));
  }
}
