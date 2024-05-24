part of 'detection_bloc.dart';

@immutable
sealed class DetectionEvent extends Equatable {
  const DetectionEvent();
  @override
  List<Object> get props => [];
}

class PerformInference extends DetectionEvent {
  final Uint8List image;

  const PerformInference({required this.image});
}
