import 'dart:convert';
import 'package:allamvizsga/screens/Mainscreens/BusTT/widget/buscard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/network/constants.dart' as constant;

class DropDownItem {
  final String value;
  final String label;
  String idInduloMegallo;
  String megallosorrend;

  DropDownItem({
    required this.value,
    required this.label,
    required this.idInduloMegallo,
    required this.megallosorrend,
  });
}

class Bus {
  final DropDownItem source;
  final DropDownItem destination;
  String vonal;
  final String erkezesiido;
  final String megallasiido;

  Bus({
    required this.source,
    required this.destination,
    required this.vonal,
    required this.erkezesiido,
    required this.megallasiido,
  });
}

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  _BusScreenState createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  List<DropDownItem> cities = [];
  List<DropDownItem> destinationCities = [];
  DropDownItem? sourceCity;
  DropDownItem? destinationCity;
  bool isSearchPressed = false;
  final List<Bus> buses = [];

  @override
  void initState() {
    super.initState();
    fetchMegallo();
  }

  Future<void> fetchMegallo() async {
    final response = await http.get(Uri.parse('${constant.cim}megallok.php'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        cities = responseData.map((item) =>
            DropDownItem(
                value: item['id_megallo'],
                label: item['megallo_neve'],
                idInduloMegallo: item['id_indulo_megallo'],
                megallosorrend: item['id_megallo'])).toList();
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

  void fetchDestinationCities() {
    setState(() {
      destinationCities = cities
          .where((item) =>
      item.idInduloMegallo == sourceCity?.idInduloMegallo &&
          (int.tryParse(item.megallosorrend) ?? 0) > (int.tryParse(sourceCity?.megallosorrend ?? '0') ?? 0))
          .toList();
    });
  }

  Future<String> fetchVonalszam(String sourceCityId, String destinationCityId) async {
    final response = await http.get(Uri.parse('${constant
        .cim}vonalszam.php?sourceCity=$sourceCityId&destinationCity=$destinationCityId'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch vonalszam');
    }
  }

  Future<List<String>> fetchUtazasIdo(String sourceCityId, String destinationCityId) async {
    final response = await http.get(
      Uri.parse('${constant.cim}utazasido.php?sourceCityId=$sourceCityId&destinationCityId=$destinationCityId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<String> departureTimes = List<String>.from(responseData['departureTimes']);
      String erkezesiido = 'Nincs';
      String megallasiido = 'Nincs ';

      if (departureTimes.length > 0) {
        erkezesiido = departureTimes[0];
      }
      if (departureTimes.length > 1) {
        megallasiido = departureTimes[1];
      }

      return [erkezesiido, megallasiido];
    } else {
      throw Exception('Failed to fetch departure times');
    }
  }



  void searchBuses() async {
    setState(() {
      isSearchPressed = true;
      buses.clear();
    });

    try {
      String vonal = await fetchVonalszam(sourceCity!.idInduloMegallo, destinationCity!.idInduloMegallo);

      if (vonal.isEmpty || vonal == '0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nincs buszjárat'),
          ),
        );
      } else {
        List<String> utazasIdo = await fetchUtazasIdo(sourceCity!.value, destinationCity!.value);

        setState(() {
          buses.add(
            Bus(
              source: sourceCity!,
              destination: destinationCity!,
              vonal: vonal,
              erkezesiido: utazasIdo.isNotEmpty ? utazasIdo[0] : 'Nincs elérhető utazási idő',
              megallasiido: utazasIdo.isNotEmpty ? utazasIdo[1] : 'Nincs elérhető utazási idő',
            ),
          );
        });
      }
    } catch (e) {
      print('Hiba történt az utazási idők lekérdezése közben: $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            'Buszjárat',
            style: TextStyle(
              fontFamily: 'Graduate',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Honnan?',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      hint: Text('Honnan szeretne?'),
                      value: sourceCity?.value,
                      items: cities.map((item) {
                        return DropdownMenuItem(
                          value: item.value,
                          child: Text(item.label),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          sourceCity = cities.firstWhere((element) =>
                          element.value == value);
                          fetchDestinationCities(); // Új úticél városok lekérése
                          destinationCity = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hova?',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      hint: Text('Hová szeretne?'),
                      value: destinationCity?.value,
                      items: destinationCities.map((item) {
                        return DropdownMenuItem(
                          value: item.value,
                          child: Text(item.label),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          destinationCity = destinationCities.firstWhere((
                              element) => element.value == value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          TextButton.icon(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              searchBuses();
            },
            label: Text(
              'Keresés',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: isSearchPressed
                ? buses.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: buses.length,
              itemBuilder: (context, index) => BusCard(
                bus: buses[index],
                sourceCity: sourceCity,
                destinationCity: destinationCity,
              ),
            )
                : Container(),
          ),
        ],
      ),
    );
  }
}