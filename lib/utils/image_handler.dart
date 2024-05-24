import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageHandler {
  final ImagePicker picker = ImagePicker();

  Future<String> pickImageFromGallery(BuildContext context) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      return pickedImage.path;
    } else {
      throw Exception('No image choosen');
    }
  }

  Future<String> pickImageFromCamera(BuildContext context) async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      return pickedImage.path;
    } else {
      throw Exception('No image choosen');
    }
  }

  Future<Uint8List> preprocessImage(File image) async {
    img.Image? originalImage = img.decodeImage(await image.readAsBytes());
    img.Image resizedImage = img.copyResize(originalImage!, width: 224, height: 224);

    if (resizedImage.numChannels == 4) {
      var imageDst = img.Image(
        width: resizedImage.width,
        height: resizedImage.height,
      )..clear(
          img.ColorRgb8(255, 255, 255),
        );
      resizedImage = img.compositeImage(
        imageDst,
        resizedImage,
      );
    }

    Uint8List bytes = resizedImage.getBytes();
    return bytes;
  }
}
