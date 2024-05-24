import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ai_detection_app/features/result/view/screens/result_screen.dart';
import 'package:ai_detection_app/features/upload/bloc/detection_bloc.dart';
import 'package:ai_detection_app/utils/custom_container.dart';
import 'package:ai_detection_app/utils/image_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

bool isImageUploaded = false;

class _UploadScreenState extends State<UploadScreen> {
  final imageHandler = ImageHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Logo(),
            const Spacer(),
            ImageUploadSection(
              detectionBlocContext: context,
              imageHandler: imageHandler,
            ),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/blink.png',
          height: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          'aidect',
          style: TextStyle(
            fontSize: 26,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ImageUploadSection extends StatefulWidget {
  final BuildContext detectionBlocContext;
  final ImageHandler imageHandler;

  const ImageUploadSection({
    super.key,
    required this.detectionBlocContext,
    required this.imageHandler,
  });

  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  String? image;
  Uint8List? processedImage;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<DetectionBloc, DetectionState>(
      listener: (context, state) {
        print(state);
        if (state is DetectionProcess) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is DetectionSuccess) {
          setState(() {
            isLoading = false;
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ResultScreen(
                  image: image!,
                  result: state.inference,
                ),
                childCurrent: Container(),
              ),
            );
          });
        }
        if (state is DetectionFailure) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                useSafeArea: false,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(26),
                    decoration: roundedBorderBoxDecoration(context: context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String imagePath = await widget.imageHandler.pickImageFromCamera(context);
                            Uint8List imageBytes = await widget.imageHandler.preprocessImage(File(imagePath));
                            setState(() {
                              image = imagePath;
                              processedImage = imageBytes;
                            });
                          },
                          child: Icon(
                            CupertinoIcons.photo_camera_solid,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String imagePath = await widget.imageHandler.pickImageFromGallery(context);
                            Uint8List imageBytes = await widget.imageHandler.preprocessImage(File(imagePath));
                            setState(() {
                              image = imagePath;
                              processedImage = imageBytes;
                            });
                          },
                          child: Icon(
                            CupertinoIcons.folder_solid,
                            size: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              width: image == null ? MediaQuery.of(context).size.width * 0.6 : null,
              height: image == null ? MediaQuery.of(context).size.height * 0.6 : null,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
              decoration: roundedBorderBoxDecoration(context: context),
              child: image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'upload an image',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Image.asset(
                          'assets/images/uploading.png',
                          height: 28,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    )
                  : Animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      child: ClipOval(
                        child: Stack(children: [
                          Image.file(
                            File(image!),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width * 0.7,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                          Positioned(
                            bottom: 0,
                            top: 0,
                            left: 0,
                            right: 0,
                            child: isLoading
                                ? LoadingAnimationWidget.hexagonDots(
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : Container(),
                          ),
                        ]),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 40),
          image == null
              ? Container()
              : Animate(
                  effects: const [FadeEffect(), ScaleEffect()],
                  child: ClickToDetect(
                    detectionBlocContext: widget.detectionBlocContext,
                    image: processedImage!,
                  ),
                ),
        ],
      ),
    );
  }
}

class ClickToDetect extends StatelessWidget {
  final BuildContext detectionBlocContext;
  final Uint8List image;

  const ClickToDetect({
    super.key,
    required this.detectionBlocContext,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          context.read<DetectionBloc>().add(
                PerformInference(image: image),
              );
        },
        child: Container(
          width: 200,
          height: 60,
          decoration: roundedBorderBoxDecoration(context: context),
          child: Center(
            child: Text(
              'detect',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
