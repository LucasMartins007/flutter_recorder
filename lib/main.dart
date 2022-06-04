import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getvideo/tabs/photo/PhotoTab.dart';
import 'package:getvideo/tabs/video/VideosTab.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('Video Recorder'),
            ),
            backgroundColor: Colors.lightGreen,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                _getFormattedTab("Vídeos", Icons.video_camera_back_rounded),
                _getFormattedTab("Fotos", Icons.photo),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              VideosTab(),
              PhotosTab(),
            ],
          ),
        ),
      ),
    );
  }

  Container _getFormattedTab(String tabText, IconData tabIcon) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(tabIcon),
          Text(
            tabText,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
