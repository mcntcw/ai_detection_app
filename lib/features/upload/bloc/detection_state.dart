part of 'detection_bloc.dart';

@immutable
sealed class DetectionState extends Equatable {
  const DetectionState();
  @override
  List<Object> get props => [];
}

final class DetectionInitial extends DetectionState {}

final class DetectionProcess extends DetectionState {}

final class DetectionSuccess extends DetectionState {
  final Map<String, int> inference;

  const DetectionSuccess(this.inference);
}

final class DetectionFailure extends DetectionState {}
