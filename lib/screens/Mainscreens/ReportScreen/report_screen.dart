import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:http/http.dart' as http;
import 'package:allamvizsga/network/constants.dart' as constant;

import '../News/news_screen.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedCategory;
  String? selectedCategoryId;
  LatLng? currentLatLng;
  TextEditingController descriptionController = TextEditingController();
  String? placeName;
  XFile? image;
  List<Map<String, dynamic>> categories = [];

  Future<void> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        placeName = "${place.locality}, ${place.country}";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    currentLatLng =
        LatLng(locationData.latitude!, locationData.longitude!);
    await getLocationName(
        locationData.latitude!, locationData.longitude!);
    setState(() {});
  }

  bool showMap = false;

  final Location location = Location();
  late LocationData locationData;

  @override
  void initState() {
    super.initState();
    getCategories();
    getLocation();
  }

  Future<void> getCategories() async {
    final url = Uri.parse('${constant.cim}get_categories.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(data.map((item) =>
          {'id': item['id'].toString(), 'category': item['category']}));
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error getting categories: $e');
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> sendReport() async {
    final url = Uri.parse('${constant.cim}bejelentes.php');

    var request = http.MultipartRequest('POST', url);
    request.fields['description'] = descriptionController.text;
    request.fields['latitude'] = currentLatLng?.latitude.toString() ?? '';
    request.fields['longitude'] = currentLatLng?.longitude.toString() ?? '';
    request.fields['category_id'] = selectedCategoryId ?? '';

    if (image == null) {
      print('No image selected');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Please select an image'),
          );
        },
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      return;
    }

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image!.path,
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Report sent successfully');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Report sent successfully'),
          );
        },
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        image = null;
        showMap = false;
        descriptionController.clear();
        selectedCategory = null;
        selectedCategoryId = null;
      });
    } else {
      print('Failed to send report. Status code: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Failed to send report'),
          );
        },
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.white, Colors.transparent],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.12,
          ),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      'assets/background.jpg',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.10,
                      child: Center(
                        child: Text(
                          'Bejelentés',
                          style: GoogleFonts.italiana(
                            textStyle: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10.0),
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      await pickImage();
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: image == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Kép',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          Icon(Icons.camera_alt_outlined,
                              color: Colors.white, size: 50),
                        ],
                      )
                          : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white70,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 20, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await getLocation();
                      setState(() {
                        showMap = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: showMap
                          ? (currentLatLng != null
                          ? SizedBox(
                        height: 100,
                        width: 100,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: currentLatLng!,
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('current_location'),
                              position: currentLatLng!,
                            ),
                          },
                        ),
                      )
                          : Center(child: CircularProgressIndicator()))
                          : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Térkép',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 2),
                          Icon(Icons.map,
                              color: Colors.white, size: 50),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: ('Leírás'),
                        hintStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        hint: const Text('Kategória',
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                        dropdownColor: Colors.grey,
                        style: const TextStyle(color: Colors.white),
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['category'],
                            child: Text(
                              category['category'],
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                            selectedCategoryId = categories
                                .firstWhere((element) =>
                            element['category'] == newValue)['id'];
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await sendReport();
                  },
                  child: Text(
                    'Bejelentés',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
