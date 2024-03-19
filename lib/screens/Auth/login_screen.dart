// login_screen.dart

import 'dart:convert';

import 'package:allamvizsga/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'registration_screen.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    String uri = "http://192.168.1.105/user_api/login.php";
    var res = await http.post(Uri.parse(uri), body: {
      "email": _emailController.text,
      "password": _passwordController.text,
    });

    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(userId: response["userId"])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/login.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: Text(
              "Login",
              style: GoogleFonts.italiana(
                textStyle: TextStyle(
                    fontSize: 34,
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
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.orangeAccent,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          )
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.orangeAccent,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          )
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ForgotPasswordScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      login();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        minimumSize: Size(200, 50)),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Google Italianno',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return RegistrationScreen();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final tween = Tween(
                                  begin: 0.0,
                                  end: 1.0,
                                );
                                return ScaleTransition(
                                  scale: animation.drive(tween),
                                  child: child!,
                                );
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

