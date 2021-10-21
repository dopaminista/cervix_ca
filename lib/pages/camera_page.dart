import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'analysis_page.dart';

// import 'package:cervix_ca/state_management/widget_controller.dart';
// import 'package:provider/provider.dart';
double _minAvailableZoom = 1.0;
double _maxAvailableZoom = 1.0;
double _currentZoomLevel = 1.0;

double _minAvailableExposureOffset = 0.0;
double _maxAvailableExposureOffset = 0.0;
double _currentExposureOffset = 0.0;

const resolutionPresets = ResolutionPreset.values;
ResolutionPreset currentResolutionPreset = ResolutionPreset.max;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      currentResolutionPreset,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    // _controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value);

    // _controller.getMinZoomLevel().then((value) => _minAvailableZoom = value);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _controller
                .getMinExposureOffset()
                .then((value) => _minAvailableExposureOffset = value);

            _controller
                .getMaxExposureOffset()
                .then((value) => _maxAvailableExposureOffset = value);
            _controller
                .getMaxZoomLevel()
                .then((value) => _maxAvailableZoom = value);

            _controller
                .getMinZoomLevel()
                .then((value) => _minAvailableZoom = value);
            // If the Future is complete, display the preview.
            return Column(
              children: [
                // Expanded(flex: 1, child: Container(color: Colors.black)),
                Stack(alignment: Alignment.centerRight, children: [
                  CameraPreview(_controller),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _currentExposureOffset.toStringAsFixed(1) + 'x',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Container(
                          height: 30,
                          child: Slider(
                            value: _currentExposureOffset,
                            min: _minAvailableExposureOffset,
                            max: _maxAvailableExposureOffset,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white30,
                            onChanged: (value) async {
                              setState(() {
                                _currentExposureOffset = value;
                              });
                              await _controller.setExposureOffset(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // DropdownButton<ResolutionPreset>(
                  //   dropdownColor: Colors.black87,
                  //   underline: Container(),
                  //   value: currentResolutionPreset,
                  //   items: [
                  //     for (ResolutionPreset preset in resolutionPresets)
                  //       DropdownMenuItem(
                  //         child: Text(
                  //           preset.toString().split('.')[1].toUpperCase(),
                  //           style: const TextStyle(color: Colors.white),
                  //         ),
                  //         value: preset,
                  //       )
                  //   ],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       currentResolutionPreset = value!;
                  //       // _isCameraInitialized = false;
                  //     });
                  //     // onNewCameraSelected(controller!.description);
                  //   },
                  //   hint: const Text("Select item"),
                  // )
                ]),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _currentZoomLevel,
                                min: _minAvailableZoom,
                                max: _maxAvailableZoom,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white30,
                                onChanged: (value) async {
                                  setState(() {
                                    _currentZoomLevel = value;
                                  });
                                  await _controller.setZoomLevel(value);
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _currentZoomLevel.toStringAsFixed(1) + 'x',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              try {
                                // Ensure that the camera is initialized.
                                await _initializeControllerFuture;

                                // Attempt to take a picture and get the file `image`
                                // where it was saved.
                                final image = await _controller.takePicture();

                                // If the picture was taken, display it on a new screen.
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DisplayPictureScreen(
                                      // Pass the automatically generated path to
                                      // the DisplayPictureScreen widget.
                                      imagePath: image.path,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                // If an error occurs, log the error to the console.
                                print(e);
                              }
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   // Provide an onPressed callback.
      //   onPressed: () async {
      //     // Take the Picture in a try / catch block. If anything goes wrong,
      //     // catch the error.
      // try {
      //   // Ensure that the camera is initialized.
      //   await _initializeControllerFuture;

      //   // Attempt to take a picture and get the file `image`
      //   // where it was saved.
      //   final image = await _controller.takePicture();

      //   // If the picture was taken, display it on a new screen.
      //   await Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => DisplayPictureScreen(
      //         // Pass the automatically generated path to
      //         // the DisplayPictureScreen widget.
      //         imagePath: image.path,
      //       ),
      //     ),
      //   );
      // } catch (e) {
      //   // If an error occurs, log the error to the console.
      //   print(e);
      // }
      //   },
      //   child: const Icon(Icons.camera_alt),
      // ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List<Widget> childs = [
    Container(),
    Expanded(
      child: Container(
        color: Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: FractionallySizedBox(
                heightFactor: 0.5,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white70, shape: BoxShape.circle),
                    child: const Icon(Icons.done, color: Colors.white)),
              ),
            ),
            Builder(builder: (context) {
              return Expanded(
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white70, shape: BoxShape.circle),
                        child: const Icon(Icons.refresh, color: Colors.white)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ),
  ];
  int _childIndex = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _childIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.file(File(widget.imagePath)),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: 0.5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AnalysisPage(imagePath: widget.imagePath)));
                        },
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white70, shape: BoxShape.circle),
                            child: const Icon(Icons.done, color: Colors.white)),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return Expanded(
                      child: FractionallySizedBox(
                        heightFactor: 0.5,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white70,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.refresh,
                                  color: Colors.white)),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // AnimatedSwitcher(
          //   duration: const Duration(seconds: 1),
          //   child: childs[_childIndex],
          // ),
        ],
      ),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// List<CameraDescription>? cameras;

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   runApp(CameraApp());
// // }

// class CameraApp extends StatefulWidget {
//   @override
//   _CameraAppState createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   late CameraController controller;

//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () async {
//       print('cameras function is worked');
//       cameras = await availableCameras();
//     });

//     super.initState();
//     controller = CameraController(cameras![0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(controller),
//     );
//   }
// }
