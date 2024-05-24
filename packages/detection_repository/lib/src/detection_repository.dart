import 'dart:developer';
import 'package:detection_repository/src/abstract_detection_repository.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:math' as math;

class TensorFlowDetectionRepository implements DetectionRepository {
  @override
  Future<tfl.Interpreter> loadModel() async {
    try {
      tfl.Interpreter interpreter = await tfl.Interpreter.fromAsset('assets/tflite/model.tflite');
      return interpreter;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<String>> loadLabels() async {
    try {
      String labelsData = await rootBundle.loadString('assets/tflite/labels.txt');
      return labelsData.split('\n');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, int>> performInference(Uint8List image) async {
    try {
      List<dynamic> input = image.buffer.asUint8List().reshape([1, 224, 224, 3]);
      List<dynamic> outputShape = List<int>.filled(1 * 1001, 0).reshape([1, 1001]);
      tfl.Interpreter interpreter = await loadModel();
      List<String> labels = await loadLabels();

      interpreter.run(input, outputShape);

      List<int> output = outputShape[0];

      int maxScore = output.reduce(math.max);
      int probability = ((maxScore / 255) * 100).toInt();
      int highestIndex = output.indexOf(maxScore);

      Map<String, int> inference = {labels[highestIndex]: probability};

      interpreter.close();

      return inference;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
