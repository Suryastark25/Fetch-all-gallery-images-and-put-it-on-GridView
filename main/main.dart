import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<XFile>? _imageFiles;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    if (await Permission.photos.request().isGranted) {
      _fetchImages();
    }
  }

  Future<void> _fetchImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _imageFiles = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: _fetchImages,
          ),
        ],
      ),
      body: _imageFiles == null
          ? Center(child: Text('No images selected.'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: _imageFiles!.length,
              itemBuilder: (context, index) {
                return Image.file(
                  File(_imageFiles![index].path),
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
