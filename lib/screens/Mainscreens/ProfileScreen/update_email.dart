import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
          Uri.parse("http://192.168.1.105/user_api/update_email.php"),
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
        title: Text("Update Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _newEmailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEmail,
                child: Text("Update Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
