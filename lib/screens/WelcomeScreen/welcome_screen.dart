import 'package:allamvizsga/screens/Auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "We Have\nExperts For You",
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
                        ]
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 55,
                  width: 220,
                  margin: const EdgeInsets.only(
                    top: 40,
                    bottom: 30,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const LoginScreen();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final tween = Tween(
                              begin: 0.0,
                              end: 1.0,
                            );
                            return FadeTransition(
                              opacity: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Text(
                      'Start Experience',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Google Italianno', // Google Italianno Regular 400 font
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
