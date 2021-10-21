import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

class WidgetController with ChangeNotifier, DiagnosticableTreeMixin {
  CameraDescription? camera;
  WidgetController({this.camera});
}

// 