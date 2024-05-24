import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:detection_repository/detection_repository_library.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detection_event.dart';
part 'detection_state.dart';

class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  final DetectionRepository _detectionRepository;

  DetectionBloc({required DetectionRepository detectionRepository})
      : _detectionRepository = detectionRepository,
        super(DetectionInitial()) {
    on<PerformInference>((event, emit) async {
      emit(DetectionProcess());
      try {
        Map<String, int> inference = await _detectionRepository.performInference(event.image);
        emit(DetectionSuccess(inference));
      } catch (e) {
        emit(DetectionFailure());
      }
    });
  }
}
