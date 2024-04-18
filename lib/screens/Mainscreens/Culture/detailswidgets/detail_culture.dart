import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constant;

class DetailListScreen extends StatefulWidget {
  final String idDoc;

  const DetailListScreen({Key? key, required this.idDoc}) : super(key: key);

  @override
  _DetailListScreenState createState() => _DetailListScreenState();
}

class _DetailListScreenState extends State<DetailListScreen> {
  late Future<Map<String, dynamic>> fetchDataFuture;


  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    print('idDoc: ${widget.idDoc}');
  }

  Future<Map<String, dynamic>> fetchData() async {
    final String idDoc = widget.idDoc;
    final String url = '${constant.cim}detail_culture.php?id=$idDoc';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList.first;
        return data;
      } else {
        throw Exception('No data available for the specified ID');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final Map<String, dynamic> cultureData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(cultureData['name'] ?? ''),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kulturális program részleteinek megjelenítése
                  Image.network(
                    cultureData['image1'], // kép URL
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cultureData['name'], // név
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          cultureData['city'], // város
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          cultureData['typeC'], // információ
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                                child: Image.network(
                                  cultureData['image1'],
                                  width: 170,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                                child: Image.network(
                                  cultureData['image2'],
                                  width: 170,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                                child: Image.network(
                                  cultureData['image3'],
                                  width: 170,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cultureData['locationC'], // helyszín
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cultureData['Phone'], // kapcsolat
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Visszalépés a korábbi képernyőre
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // háttérszín
                              foregroundColor: Colors.white, // előtérszín
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
