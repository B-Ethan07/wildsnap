import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? pickedImage;

  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile;
      });
    }
  }

  Widget _buildImageWidget() {
    if (pickedImage == null) {
      return const Center(child: Text('No image selected'));
    }

    if (kIsWeb) {
      // Sur le web, on utilise Image.network
      return Image.network(pickedImage!.path);
    } else {
      // Sur mobile, on utilise Image.file
      return Image.file(File(pickedImage!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(24),
              ),
              onPressed: () => pickImage(ImageSource.camera),
              child: const Icon(
                Icons.photo_camera,
                size: 34,
              ),
            ),
            SizedBox(
              width: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(24),
              ),
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Icon(
                Icons.photo_library,
                size: 34,
              ),
            ),
          ]
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width /1.2,
          width: MediaQuery.of(context).size.width /1.2,
          child: _buildImageWidget(),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
