import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/test.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'This is a test screen',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
