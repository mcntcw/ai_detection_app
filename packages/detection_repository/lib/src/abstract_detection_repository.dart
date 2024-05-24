import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

abstract class DetectionRepository {
  Future<Interpreter> loadModel();
  Future<List<String>> loadLabels();
  Future<Map<String, int>> performInference(Uint8List image);
}
