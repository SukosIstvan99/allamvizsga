import 'dart:math';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final List<String> randomFacts = [
    "A földön található kőzetek több mint 75%-a szilícium és oxigén keveréke.",
    "A méheket repülés közben aerodinamikai törvények is irányítják.",
    "Az átlagos felhő kb. 1 millió tonna súlyú.",
    "Az elefántok a legnagyobb szárazföldi állatok.",
    "A leghosszabb emberi életet Jeanne Calment érte el, aki 122 évet és 164 napot élt."
  ];

  String getRandomFact() {
    Random random = Random();
    return randomFacts[random.nextInt(randomFacts.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 5; i++)
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  getRandomFact(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
