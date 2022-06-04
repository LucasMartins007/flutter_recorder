import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

class Controller {
  static Future<UploadTask> upload(String path, String diretory,
      String extension, FirebaseStorage storage) async {
    File file = File(path);
    try {
      String ref = '$diretory/${DateTime.now().toString()}.$extension';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  static Future<void> saveInGallery(String path, String directory) async {
    await ImagesPicker.saveVideoToAlbum(File(path), albumName: directory);
  }

  static ButtonStyle getButtonStyle() {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        const Size(200, 50),
      ),
      backgroundColor: MaterialStateProperty.all(
        Colors.lightGreen,
      ),
    );
  }
}
