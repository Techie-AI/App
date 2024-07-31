import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://www.example.com/sample-image.jpg', // Replace with your image URL
      fit: BoxFit.cover,
    );
  }
}
