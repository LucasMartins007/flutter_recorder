import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getvideo/Controller.dart';
import 'package:getvideo/tabs/photo/PhotoController.dart';
import 'package:getvideo/widgets/TextFieldWidget.dart';
import 'package:images_picker/images_picker.dart';

class PhotosTab extends StatefulWidget {
  const PhotosTab({Key? key}) : super(key: key);

  @override
  State<PhotosTab> createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _nomeController = TextEditingController();
  final List<String> arquivos = [];
  late Media media;
  List<Reference> refs = [];
  bool loading = true;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  _loadPhotos() async {
    refs = (await storage.ref(PhotoController.imagesDirectory).listAll()).items;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    setState(() => loading = false);
  }

  _photoTakerListener(UploadTask task) async {
    task.snapshotEvents.listen((TaskSnapshot snapshot) async {
      if (snapshot.state == TaskState.running) {
        setState(() {
          uploading = true;
        });
        return;
      }
      if (snapshot.state == TaskState.success) {
        arquivos.add(await snapshot.ref.getDownloadURL());
        refs.add(snapshot.ref);
        setState(
          () => uploading = false,
        );
      }
    });
  }

  _uploadPhoto() async {
    List<Media>? takenPhotos = await PhotoController.takePhoto();
    if (takenPhotos != null) {
      String? managedName = _nomeController.text == "" ? null : _nomeController.text;
      UploadTask task = await PhotoController.uploadPhoto(takenPhotos, storage, managedName);
      await _photoTakerListener(task);

      await PhotoController.savePhotoIntoGallery(takenPhotos);
    }
  }

  _sharePhoto(int index) async => PhotoController.sharePhoto(refs[index]);

  _deletePhoto(int index) async {
    Controller.delete(storage, refs[index]);
    arquivos.removeAt(index);
    refs.removeAt(index);

    setState(() => {});
  }

  SingleChildRenderObjectWidget _showImageList() {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : arquivos.isEmpty
            ? const Center(
                child: Text('Não há imagens salvas.'),
              )
            : SizedBox(
                height: 550,
                child: ListView.builder(
                  itemCount: arquivos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(
                          bottom: 10, left: 20, right: 20),
                      title: Container(
                        padding:
                            const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const SizedBox(
                                    width: 20,
                                    height: 50,
                                    child: Icon(Icons.photo),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    refs[index].fullPath,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _sharePhoto(index),
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _deletePhoto(index),
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 350,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFieldWidget(
                      controller: _nomeController,
                      labelText: "Descrição da imagem",
                      hintText: "Informe a descrição da imagem",
                      textInputType: TextInputType.text,
                      uploadFunction: () => _uploadPhoto(),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: _showImageList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
