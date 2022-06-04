import 'package:firebase_storage/firebase_storage.dart';
import 'package:getvideo/Controller.dart';
import 'package:images_picker/images_picker.dart';
import 'package:social_share/social_share.dart';

class PhotoController {
  static const String imagesDirectory = "images";
  static const String imagesExtension = "jpeg";

  static Future<UploadTask> uploadPhoto(
      List<Media> takenPhotos, FirebaseStorage storage, String? name) async {
    return await Controller.upload(
        takenPhotos.first.path, imagesDirectory, imagesExtension, storage, name);
  }

  static savePhotoIntoGallery(List<Media> photoTaken) async {
    await Controller.saveInGallery(photoTaken.first.path, imagesDirectory);
  }

  static Future<List<Media>?> takePhoto() async {
    return ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 1,
      maxSize: 800,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.wh16x9,
      ),
    );
  }

  static sharePhoto(Reference reference) async {
    String path = await reference.getDownloadURL();
    SocialShare.shareOptions(
      "Compartilhe a imagem $path entre seu amigos!",
    );
  }
}
