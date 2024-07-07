import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';

class ImageFunctions {
  static Future<File?> cameraPicker() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<File?> galleryPicker() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request();
      }
    } else {
      status = await Permission.photos.request();
    }
    if (status.isGranted) {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path);
      }
    }
    return null;
  }

  static Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      // Get the current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user signed in");
      }

      // Check if the user already has a profile image stored
      String? oldImageUrl = await FirebaseUtils.getUserProfileImage(currentUser.uid);

      // Generate a unique filename for the new image
      String fileName = "profile_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Upload the new image to Firebase Storage
      final Reference storageReference = FirebaseStorage.instance.ref().child("profile_images/$fileName");
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the new uploaded image
      String imageUrl = await storageReference.getDownloadURL();

      // Store the download URL in the user's profile in Firestore
      await FirebaseUtils.updateUserProfileImage(currentUser.uid, imageUrl);

      // Delete the old image if it exists
      if (oldImageUrl != null) {
        Reference oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
        await oldImageRef.delete();
      }

      return imageUrl;
    } catch (error) {
      print("Error uploading image: $error");
      return null;
    }
  }


}
