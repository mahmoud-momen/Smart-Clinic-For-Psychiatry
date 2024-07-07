import 'dart:io';
import 'package:flutter/material.dart';

class ImageProvider extends ChangeNotifier {
  File? _pickedImage;

  File? get pickedImage => _pickedImage;

  void setPickedImage(File? image) {
    _pickedImage = image;
    notifyListeners();
  }
}
