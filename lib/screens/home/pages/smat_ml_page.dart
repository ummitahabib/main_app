import 'package:beamer/beamer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SmatMlPage extends StatefulWidget {
  const SmatMlPage({Key? key}) : super(key: key);

  @override
  _SmatMlPageState createState() => _SmatMlPageState();
}

class _SmatMlPageState extends State<SmatMlPage> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initController;
  bool isCameraReady = false;
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    initCamera();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) initCamera();
  }

  Widget cameraWidget() {
    final camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _initController,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  cameraWidget(),
                  Column(
                    children: [
                      Container(
                        width: size.width,
                        color: AppColors.black,
                        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Scan Leaf',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'semibold',
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pandora.logAPPButtonClicksEvent('FARM_PROBE_BACK_BUTTON_CLICKED');

                                    if (kIsWeb) {
                                      context.beamToReplacementNamed(ConfigRoute.mainPage);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Place plant leaf inside frame to scan. Please\nkeep your device steady when scanning to ensure accurate results',
                              style: Styles.smatCrowSubParagraphRegular(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/nsvgs/ml/scan.png',
                            width: 250,
                            height: 250,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(),
                              FloatingActionButton.extended(
                                icon: const Icon(Icons.camera_alt, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                label: Text(
                                  'Scan Plant Leaf',
                                  style: Styles.smatCrowSubParagraphRegular(color: Colors.white),
                                ),
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  _pandora.logAPPButtonClicksEvent('SMAT_ML_ITEM_CAPTURE_BUTTON_CLICKED');
                                  captureImage(context);
                                },
                              ),
                              const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initController = _controller.initialize();
    if (mounted) {
      setState(() {
        isCameraReady = true;
      });
    }
    setState(() {});
  }

  Future<void> captureImage(BuildContext context) async {
    final image = await _controller.takePicture();
    _pandora.reRouteUser(context, ConfigRoute.plantAnalysis, image.path);
  }
}
