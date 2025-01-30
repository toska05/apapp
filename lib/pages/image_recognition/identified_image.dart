import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Stateful widget for the Identified Image Page
class IdentifiedImagePage extends StatefulWidget {
  final XFile? image;

  const IdentifiedImagePage({super.key, required this.image});

  @override
  _IdentifiedImagePageState createState() => _IdentifiedImagePageState();
}

class _IdentifiedImagePageState extends State<IdentifiedImagePage> {
  String? plantName;
  String? commonNames;
  double? confidence;
  List<dynamic> plants = [];
  String? family;
  String? genus;

  @override
  void initState() {
    super.initState();

    // If an image is provided, start the plant identification process
    if (widget.image != null) {
      identifyPlant();
    }
  }

  // Function to identify the plant using an API
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
              plantName = responseData['results'][0]['species']
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
              plantName = "Unknown";
              commonNames = "Could not identify the plant.";
              confidence = 0;
            }
          });
        }
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error processing response: $e");
      if (mounted) {
        setState(() {
          plantName = "Unknown";
          commonNames = "Could not identify the plant.";
          confidence = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Identified Plant"),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (confidence != null && confidence! > 70)
                            const Icon(Icons.check_circle, color: Colors.green)
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
                        plantName ?? "Identifying...",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 16),
                          children: [
                            if (commonNames != null) ...[
                              const TextSpan(
                                  text: "Common Names: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "$commonNames\n"),
                            ],
                            if (family != null) ...[
                              const TextSpan(
                                  text: "Family: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "$family\n"),
                            ],
                            if (genus != null) ...[
                              const TextSpan(
                                  text: "Genus: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: "$genus"),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
