import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/network/constants.dart' as constant;

class UpdateEmailPage extends StatefulWidget {
  final String userId;
  final String currentEmail;

  const UpdateEmailPage({Key? key, required this.userId, required this.currentEmail}) : super(key: key);

  @override
  _UpdateEmailPageState createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  late TextEditingController _newEmailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _newEmailController = TextEditingController();
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    if (_formKey.currentState!.validate()) {
      String newEmail = _newEmailController.text.trim();

      try {
        var response = await http.post(
          Uri.parse("${constant.cim}update_email.php"),
          body: {
            'userId': widget.userId,
            'newEmail': newEmail,
          },
        );

        var responseData = jsonDecode(response.body);

        if (responseData['success']) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email successfully updated")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update email")));
        }
      } catch (e) {
        print("Error updating email: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred. Please try again later.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "Adja meg az új E-mail címet majd a kitöltés után nyomja meg a Frissítés gombot!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _newEmailController,
                  decoration: InputDecoration(
                    labelText: 'Új E-mail',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kérlek adj meg egy E-mail címet';
                    }
                    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Kérlek adj meg egy valós E-mail címet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                  ),
                  onPressed: _updateEmail,
                  child: Text("Email Frissítése",
                    style:TextStyle(color: Colors.white,
                    fontSize: 18) ,
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
