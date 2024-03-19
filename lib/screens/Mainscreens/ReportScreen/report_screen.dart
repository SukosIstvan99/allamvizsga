import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' hide Location;

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedCategory;
  LatLng? currentLatLng;
  TextEditingController descriptionController = TextEditingController();
  String? placeName;

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
    currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);
    await getLocationName(locationData.latitude!, locationData.longitude!);
    setState(() {});
  }

  bool showMap = false;

  //---------------------------------------------------------

  final Location location = Location();
  late LocationData locationData;
  XFile? image;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
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
            colors: [Colors.grey, Colors.white10],
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
                          'Report Page',
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
                                ]),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: image == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Photos',
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
                              width: 150, // Nagyobb szélesség
                              height: 150, // Nagyobb magasság
                            ),
                          ),
                          Positioned(
                            top: 8, // Pozíció módosítása
                            right: 8, // Pozíció módosítása
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.close,
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: showMap
                          ? (currentLatLng != null
                          ? SizedBox(
                        height: 100,
                        width: 100,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: currentLatLng!,
                            zoom: 15,
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
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'map',
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ('description'),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedCategory, // Add this line
                        hint: Text('choose',
                            style:
                            TextStyle(color: Colors.white, fontSize: 18)),
                        dropdownColor: Colors.grey,
                        style: const TextStyle(color: Colors.white),
                        items: ['Baleset', 'Veszhelyzet', 'Bejelentes']
                            .map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    // Implement report sending logic here
                  },
                  child: Text('save_report',
                    style: TextStyle(
                        color: Colors.white
                    ),
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
