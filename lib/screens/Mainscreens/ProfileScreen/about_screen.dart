import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final String termsAndConditions = '''
  Az alkalmazás felhasználói csak valós problémákat küldhetnek be!
  Az alkalmazás felhasználóinak az adatait titkosítva vannak! 
  Nagyon remélem, hogy tetszik a programom! 
  További szép napot és köszönöm a figyelmet! 
  ''';

  final String contactEmail = 'info@cityapp.com';
  final String contactnumber = '0757788888';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Felhasználói feltételek',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                termsAndConditions,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Elérhetőség',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Email: $contactEmail',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Telefonszám: $contactnumber',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
