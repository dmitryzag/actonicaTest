import 'package:flutter/material.dart';

class AdvertImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Widget buildAdvertImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(imageUrl)),
        ),
      ),
    );
  }
  }
}

