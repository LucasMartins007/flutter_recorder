import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getvideo/Controller.dart';
import 'package:images_picker/images_picker.dart';
import 'package:social_share/social_share.dart';

class VideoController {
  static const String videoDirectory = "videos";
  static const String videoExtension = "mp4";

  static Future<UploadTask> uploadVideo(
      List<Media> video, FirebaseStorage storage) async {
    return await Controller.upload(
        video.first.path, videoDirectory, videoExtension, storage, null);
  }

  static Future<List<Media>?> recordVideo(
      TextEditingController _timeController) async {
    return ImagesPicker.openCamera(
      pickType: PickType.video,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.wh16x9,
      ),
      maxTime:
          _timeController.text != "" ? int.parse(_timeController.text) : 15,
    );
  }

  static saveVideoIntoGallery(List<Media> recordedVideo) async {
    await Controller.saveInGallery(recordedVideo.first.path, videoDirectory);
  }

  static void shareVideo(Reference reference) async {
    String path = await reference.getDownloadURL();
    SocialShare.shareOptions(
      "Compartilhe o video $path entre seu amigos!",
    );
  }
}
