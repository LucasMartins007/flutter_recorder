import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getvideo/tabs/video/VideoController.dart';
import 'package:getvideo/widgets/TextFieldWidget.dart';
import 'package:images_picker/images_picker.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({Key? key}) : super(key: key);

  @override
  State<VideosTab> createState() => _VideosTabsState();
}

class _VideosTabsState extends State<VideosTab> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _timeController = TextEditingController();
  final List<String> arquivos = [];
  late Media media;
  List<Reference> refs = [];
  bool loading = true;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  _loadVideos() async {
    refs = (await storage.ref("videos").listAll()).items;
    for (var ref in refs) {
      arquivos.add(await ref.getDownloadURL());
    }
    setState(() => loading = false);
  }

  _videoRecorderListener(UploadTask task) async {
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

  Future<void> _uploadVideo() async {
    List<Media>? recordedVideos =
        await VideoController.recordVideo(_timeController);
    if (recordedVideos != null) {
      UploadTask task =
          await VideoController.uploadVideo(recordedVideos, storage);
      await _videoRecorderListener(task);

      await VideoController.saveVideoIntoGallery(recordedVideos);
    }
  }

  SingleChildRenderObjectWidget _showListVideos() {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : arquivos.isEmpty
            ? const Center(
                child: Text('Não há vídeos gravados ainda.'),
              )
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: arquivos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const SizedBox(
                        width: 20,
                        height: 50,
                        child: Icon(Icons.video_camera_back),
                      ),
                      title: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                refs[index].fullPath,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  VideoController.compartilharVideo(
                                      refs[index]),
                              icon: const Icon(Icons.share),
                            ),
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
                      controller: _timeController,
                      labelText: "Tempo do vídeo",
                      hintText: "Informe o tempo do vídeo",
                      uploadFunction: () async => await _uploadVideo(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: _showListVideos(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
