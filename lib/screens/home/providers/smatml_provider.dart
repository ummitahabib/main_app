import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../pandora/pandora.dart';

class SmatMlProvider extends ChangeNotifier {
  late CameraController _controller;
  late Future<void> initController;
  bool isCameraReady = false;
  final Pandora _pandora = Pandora();

  bool get mounted => false;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    initController = _controller.initialize();
    if (mounted) {
      isCameraReady = true;
      notifyListeners();
    }
  }

  Future<void> captureImage(BuildContext context) async {
    final image = await _controller.takePicture();
    _pandora.reRouteUser(context, '/plantAnalysis', image.path);
  }
}
