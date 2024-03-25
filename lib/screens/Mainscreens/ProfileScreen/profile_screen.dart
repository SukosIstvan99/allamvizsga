import 'package:allamvizsga/network/apiclient.dart';
import 'package:allamvizsga/screens/Mainscreens/ProfileScreen/about_screen.dart';
import 'package:allamvizsga/screens/Mainscreens/ProfileScreen/send_feedback.dart';
import 'package:allamvizsga/screens/Mainscreens/ProfileScreen/update_email.dart';
import 'package:flutter/material.dart';
import 'package:allamvizsga/screens/Auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _profilePictureUrl;
  bool _isLoading = true;


  Future<void> getProfileData() async {
    String uri = "http://192.168.1.105/user_api/profile.php?user_id=${widget.userId}";
    try {
      var response = await http.get(Uri.parse(uri));
      var userData = jsonDecode(response.body);
      if (userData.isNotEmpty) {
        setState(() {
          _firstName = userData[0]["firstName"];
          _lastName = userData[0]["lastName"];
          _email = userData[0]["email"];
          _profilePictureUrl = userData[0]["profile_picture"] ?? 'assets/profile.png';
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  Future<void> logout() async {
    try {
      setState(() {
        _firstName = '';
        _lastName = '';
        _email = '';
        _profilePictureUrl = '';
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print('Hiba történt a kijelentkezés során: $e');
    }
  }

  Future<void> changeProfilePicture() async {
    final ImagePicker _picker = ImagePicker();

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        ApiClient apiClient = ApiClient(client: http.Client());
        final response = await apiClient.uploadCameraPhoto(uid: widget.userId, files: [pickedFile.path]);

        if (response.success == true) {
          // Kép sikeresen feltöltve, kezeljük az új képet
          String imageUrl = response.image;
          setState(() {
            _profilePictureUrl = imageUrl;
          });
        }else {
          print('Hiba történt a kép feltöltésekor: ${response.message}');
        }
      }
    } catch (e) {
      print('Hiba történt a kép kiválasztásakor: $e');
    }
  }

  void _openProfileEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEmailPage(
          userId: widget.userId,
          currentEmail: _email,
        ),
      ),
    );

    if (result == true) {
      // Email updated successfully, refresh profile data
      getProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.green,
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _profilePictureUrl.isNotEmpty
                          ? CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(_profilePictureUrl),
                      )
                          : CircleAvatar(
                        radius: 100,
                        child: CircularProgressIndicator(),
                      ),
                      GestureDetector(
                        onTap: changeProfilePicture,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hello, $_firstName $_lastName !',
                    style: GoogleFonts.italiana(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 180),
                  ElevatedButton.icon(
                    onPressed: _openProfileEditScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(300, 50),
                    ),
                    icon: Icon(Icons.email, color: Colors.white),
                    label: Text(
                      'Change Email',
                      style: GoogleFonts.italiana(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SendFeedbackScreen(
                            userId: widget.userId,
                            firstName: _firstName,
                            lastName: _lastName,

                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(300, 50),
                    ),
                    icon: Icon(Icons.feedback, color: Colors.white),
                    label: Text(
                      'Send Feedback',
                      style: GoogleFonts.italiana(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return AboutScreen();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(300, 50),
                    ),
                    icon: Icon(Icons.info, color: Colors.white),
                    label: Text(
                      'About',
                      style: GoogleFonts.italiana(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      fixedSize: Size(300, 50),
                    ),
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.italiana(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
