import 'package:flutter/material.dart';

import 'login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Forgot your password?',
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
                      ]),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Enter your email address below and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 16.0, color: Colors.white, shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 3,
                    )
                  ]),
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement password reset logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text(
                    'Send Reset Link',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Navigate to login screen
                  },
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
