import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomBar extends StatelessWidget {
  // final ImagePicker _picker = ImagePicker();
  final Function getImagePicker;
  const BottomBar({super.key, required this.getImagePicker});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      height: 50,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextButton.icon(
              label: const Text(
                "Camera",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: () {
                getImagePicker(ImageSource.camera);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              label: const Text(
                "Galeria",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.image,
                color: Colors.white,
              ),
              onPressed: () {
                getImagePicker(ImageSource.gallery);
              },
            ),
          ),
        ],
      ),
    );
  }
}
