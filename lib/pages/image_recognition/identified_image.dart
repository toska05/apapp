import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Stateful widget for the Identified Image Page
class IdentifiedImagePage extends StatefulWidget {
  final XFile? image;
  final String type; // "plant" or "animal"

  IdentifiedImagePage({Key? key, required this.image, required this.type})
      : super(key: key);

  @override
  _IdentifiedImagePageState createState() => _IdentifiedImagePageState();
}

class _IdentifiedImagePageState extends State<IdentifiedImagePage> {
  late ImageLabeler labeler;
  late List<String> labels;
  final double confidenceThreshold = 0.5; // Define the confidence threshold

  String? identifiedName;
  double? confidence;

  String? commonNames;
  String? family;
  String? genus;

  String? animalScientificName;
  String? animalType;
  String? animalHabitat;
  String? animalDiet;
  String? animalLifespan;

  @override
  void initState() {
    super.initState();
    if (widget.type == "animal") {
      loadAnimalModel();
    }
    if (widget.image != null) {
      if (widget.type == "plant") {
        identifyPlant();
      } else {
        identifyAnimal();
      }
    }
  }

  // Function to identify the plant using the PlantNet API
  Future<void> identifyPlant() async {
    if (widget.image == null) return;

    final url = Uri.parse(
        "https://my-api.plantnet.org/v2/identify/all?include-related-images=false&no-reject=false&nb-results=10&lang=en&api-key=2b10X4uZzQRHqBvW86ifrX2Yu");

    var request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('images', widget.image!.path));
    request.fields['organs'] = 'leaf';

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        if (mounted) {
          setState(() {
            if (responseData.containsKey('results') &&
                responseData['results'].isNotEmpty) {
              identifiedName = responseData['results'][0]['species']
                      ['scientificNameWithoutAuthor'] ??
                  "Unknown";
              commonNames = (responseData['results'][0]['species']
                          ['commonNames'] as List?)
                      ?.join(', ') ??
                  "No common names available";
              confidence = (responseData['results'][0]['score'] ?? 0) * 100;
              family = responseData['results'][0]['species']['family']
                      ['scientificName'] ??
                  "Unknown";
              genus = responseData['results'][0]['species']['genus']
                      ['scientificName'] ??
                  "Unknown";
            } else {
              identifiedName = "Unknown";
              commonNames = "Could not identify the plant.";
              confidence = 0;
            }
          });
        }
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error processing plant identification: $e");
      if (mounted) {
        setState(() {
          identifiedName = "Unknown";
          commonNames = "Could not identify the plant.";
          confidence = 0;
        });
      }
    }
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  // Load the animal classifier model
  // Function to load the image labeler for animals
  Future<void> loadAnimalModel() async {
    try {
      final options = ImageLabelerOptions(confidenceThreshold: confidenceThreshold);
      labeler = ImageLabeler(options: options);
    } catch (e) {
      print("Error loading labeler: $e");
    }
  }

  // Function to process the animal image and label it
  Future<void> identifyAnimal() async {
    if (widget.image == null) return;

    await loadAnimalModel();

    final inputImage = InputImage.fromFilePath(widget.image!.path);
    try {
      final labels = await labeler.processImage(inputImage);

      // Sort labels based on confidence
      final sortedLabels = labels
          .where((label) => label.confidence > confidenceThreshold)
          .toList()
        ..sort((a, b) => b.confidence.compareTo(a.confidence));

      if (sortedLabels.isNotEmpty) {
        final topLabel = sortedLabels.first;
        setState(() {
          identifiedName = topLabel.label;
          confidence = topLabel.confidence * 100;
        });
        fetchAnimalInfo(identifiedName!);
      } else {
        setState(() {
          identifiedName = "Unknown";
          confidence = 0;
        });
      }
    } catch (e) {
      print("Error identifying animal: $e");
      if (mounted) {
        setState(() {
          identifiedName = "Unknown";
          confidence = 0;
        });
      }
    }
  }

  // Function to fetch animal information from API Ninjas Animals API.
  Future<void> fetchAnimalInfo(String animalName) async {
    // URL-encode the animal name to be safe for HTTP requests.
    final url = Uri.parse(
        "https://api.api-ninjas.com/v1/animals?name=${Uri.encodeComponent(animalName)}");

    try {
      final response = await http.get(url, headers: {
        'X-Api-Key':
            'qbx1DZJJ406bCZ0Jly09HQ==QcrU7b6epxLgBaIM', // Replace with your actual API key
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final animalData = data[0];
          print("Animal data: $animalData");
          setState(() {
            animalScientificName = animalData['taxonomy']["scientific_name"]?.toString() ?? "Unknown";
            animalType = animalData['taxonomy']["family"]?.toString() ?? "Unknown";
            animalHabitat = animalData['locations']?.toString() ?? "Unknown";
            animalDiet = animalData['characteristics']["diet"]?.toString() ?? "Unknown";
            animalLifespan = animalData['characteristics']['lifespan']?.toString();
          });
        } else {
          print("No animal data found for $animalName");
        }
      } else {
        print("API Ninjas HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching animal info: $e");
    }
  }

  

  @override
  Widget build(BuildContext context) {
    // Change the title based on the type of identification
    String title =
        widget.type == "plant" ? "Identified Plant" : "Identified Animal";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      body: widget.image == null
          ? const Center(child: Text("No image selected"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child:
                      Image.file(File(widget.image!.path), fit: BoxFit.cover),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (confidence != null && confidence! > 70)
                              const Icon(Icons.check_circle,
                                  color: Colors.green)
                            else if (confidence != null && confidence! > 50)
                              const Icon(Icons.warning, color: Colors.orange)
                            else
                              const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              confidence != null
                                  ? "Identified with ${confidence!.toStringAsFixed(1)}% confidence"
                                  : "Identifying...",
                              style: TextStyle(
                                fontSize: 16,
                                color: confidence != null
                                    ? (confidence! > 70
                                        ? Colors.green[700]
                                        : (confidence! > 50
                                            ? Colors.orange[700]
                                            : Colors.red[700]))
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          identifiedName ?? "Identifying...",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // Plant details
                        if (widget.type == "plant")
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 16),
                              children: [
                                if (commonNames != null) ...[
                                  const TextSpan(
                                      text: "Common Names: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$commonNames\n"),
                                ],
                                if (family != null) ...[
                                  const TextSpan(
                                      text: "Family: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$family\n"),
                                ],
                                if (genus != null) ...[
                                  const TextSpan(
                                      text: "Genus: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$genus"),
                                ],
                              ],
                            ),
                          ),
                        // Animal details
                        if (widget.type == "animal")
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 16),
                              children: [
                                if (animalScientificName != null) ...[
                                  const TextSpan(
                                      text: "Scientific Name: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$animalScientificName\n"),
                                ],
                                if (animalType != null) ...[
                                  const TextSpan(
                                      text: "Animal Type: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$animalType\n"),
                                ],
                                if (animalHabitat != null) ...[
                                  const TextSpan(
                                      text: "Habitat: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$animalHabitat\n"),
                                ],
                                if (animalDiet != null) ...[
                                  const TextSpan(
                                      text: "Diet: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$animalDiet\n"),
                                ],
                                if (animalLifespan != null) ...[
                                  const TextSpan(
                                      text: "Lifespan: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: "$animalLifespan years"),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
