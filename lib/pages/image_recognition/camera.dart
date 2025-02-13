import 'package:apapp/pages/image_recognition/identified_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  /// Default Constructor
  final String type; //plant or animal
  const Camera({super.key, required this.type});

  @override
  State<Camera> createState() {
    return _CameraState();
  }
}

class _CameraState extends State<Camera> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildUI(),
    );
  }

  /// Builds the UI for the camera screen.
  Widget _buildUI() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: Stack(
        children: [
          SizedBox.expand(
            child: CameraPreview(cameraController!),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.grey[600],
              child: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
            )
          ),
          Positioned(
            bottom: 20, // Adjust the position of the buttons
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Space between
              children: [
                // Gallery selection button (left-aligned)
                FloatingActionButton(
                  elevation: 6.0,
                  onPressed: () async {
                    final XFile? pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IdentifiedImagePage(image: pickedFile, type: widget.type),
                        ),
                      );
                    }
                  },
                  backgroundColor: Colors.grey[600],
                  child: const Icon(
                    Icons.photo,
                    size: 30,
                  ),
                ),
                // Camera capture button
                FloatingActionButton(
                  backgroundColor: Colors.grey[600],
                  elevation: 6.0,
                  onPressed: () async {
                    XFile picture = await cameraController!.takePicture();
                    Gal.putImage(picture.path);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IdentifiedImagePage(image: picture, type: widget.type),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                ),

                const Padding(
                  padding:
                      EdgeInsets.only(right: 30.0), // Add padding to the right
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sets up the camera controller by fetching available cameras and initializing the first one.
  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController =
            CameraController(cameras.first, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }
}
