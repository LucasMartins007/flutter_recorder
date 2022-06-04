import 'package:firebase_storage/firebase_storage.dart';
import 'package:getvideo/Controller.dart';
import 'package:images_picker/images_picker.dart';

class PhotoController {
  static const String imagesDirectory = "images";
  static const String imagesExtension = "jpeg";

  static Future<void> uploadPhoto(FirebaseStorage storage) async {
    List<Media>? photo = await _takePhoto();
    if (photo != null) {
      Controller.upload(
          photo.first.path, imagesDirectory, imagesExtension, storage);
    }
  }

  static Future<List<Media>?> _takePhoto() async {
    return ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 1,
      maxSize: 800,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.wh16x9,
      ),
    );
  }
}
