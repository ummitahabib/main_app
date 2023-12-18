import 'dart:io';
import 'dart:isolate';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:universal_html/html.dart' as html;

final firebaseProvider = ChangeNotifierProvider<FirebaseNotifier>((ref) {
  return FirebaseNotifier(ref);
});

class FirebaseNotifier extends ChangeNotifier {
  final Ref ref;

  FirebaseNotifier(this.ref);

  UploadTask? _imageUploadTask;
  UploadTask? get imageUploadTask => _imageUploadTask;

  bool _loading = false;
  bool get loading => _loading;

  set imageUploadTask(UploadTask? task) {
    _imageUploadTask = task;
    notifyListeners();
  }

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  String? _downloadUrl;
  String? get downloadUrl => _downloadUrl;

  set downloadUrl(String? url) {
    _downloadUrl = url;
    notifyListeners();
  }

  Future<String?> uploadImageToFirebase(
    String folder, {
    ImageSource? source,
  }) async {
    final picker = ImagePicker();
    downloadUrl = null;
    try {
      final imageFile = await picker.pickImage(source: source ?? ImageSource.gallery);
      loading = true;
      if (imageFile != null) {
        final Reference imageReference = FirebaseStorage.instance.ref().child(
              '$folder/${imageFile.path}/${TimeOfDay.now()}',
            );

        imageUploadTask = imageReference.putFile(File(imageFile.path));
        await imageUploadTask!.whenComplete(() {
          imageReference.getDownloadURL().then((url) {
            downloadUrl = url;
            loading = false;
            return url;
          });
        });
      }
      loading = false;

      return downloadUrl;
    } catch (e) {
      Pandora().logAPIEvent(
        "UPLOAD_IMAGE_TO_FIREBASE",
        emptyString,
        "Error",
        e.toString(),
      );
      snackBarMsg(e.toString());
      loading = false;
    }
    return null;
  }

  Future sendReceive(SendPort sendPort, html.File imageFileName) {
    final receivePort = ReceivePort();
    sendPort.send([imageFileName, receivePort.sendPort]);
    return receivePort.first;
  }

  Future<void> uploadImageIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final imageFileName in receivePort) {
      final imageUrl = await uploadWebFileToFirebase(
        imageFileName,
        folderPath: "/farm-manager",
      );
      sendPort.send(imageUrl);
    }
  }

  Future<String?> mainad(html.File file) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(uploadImageIsolate, receivePort.sendPort);

    final sendPort = await receivePort.first;
    final imageUrl = await sendReceive(sendPort, file);

    return imageUrl;
  }

  Future<String?> uploadWebFileToFirebase(
    html.File file, {
    String folderPath = "organization",
  }) async {
    try {
      loading = true;
      // Get the reference to the Firebase storage bucket
      final Reference storageRef = FirebaseStorage.instance.ref();

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = storageRef.child('$folderPath/${file.name}/${TimeOfDay.now()}').putBlob(file);

      // Monitor the upload process and handle completion
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      downloadUrl = await snapshot.ref.getDownloadURL();

      loading = false;
      return downloadUrl;
    } catch (e) {
      Pandora().logAPIEvent(
        "UPLOAD_WEB_IMAGE_TO_FIREBASE",
        emptyString,
        "Error",
        e.toString(),
      );
      loading = false;
      snackBarMsg('Error uploading file: $e');
      return null;
    }
  }
}
