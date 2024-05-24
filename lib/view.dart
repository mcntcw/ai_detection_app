import 'package:ai_detection_app/features/upload/bloc/detection_bloc.dart';
import 'package:ai_detection_app/features/upload/view/screens/upload_screen.dart';
import 'package:ai_detection_app/main.dart';
import 'package:detection_repository/detection_repository_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyView extends StatelessWidget {
  const MyView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Aidect',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          background: Color(0xFFB6AEA8),
          primary: Color.fromARGB(255, 48, 42, 28),
          surface: Color.fromARGB(255, 12, 12, 12),
        ),
        fontFamily: 'Fragment',
      ),
      home: BlocProvider(
        create: (context) => DetectionBloc(detectionRepository: TensorFlowDetectionRepository()),
        child: const UploadScreen(),
      ),
    );
  }
}
