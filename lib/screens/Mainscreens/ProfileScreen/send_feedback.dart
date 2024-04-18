import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/network/constants.dart' as constant;

class SendFeedbackScreen extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;

  const SendFeedbackScreen({
    Key? key,
    required this.userId,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  _SendFeedbackScreenState createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendFeedback() async {
    String feedback = _feedbackController.text;
    String url = '${constant.cim}report.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'userId': widget.userId,
          'firstName': widget.firstName,
          'lastName': widget.lastName,
          'report': feedback,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback sent successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send feedback')),
        );
      }
    } catch (e) {
      print('Error sending feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'),
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                'Számunkra fontos az ön visszajelzése',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Feedback:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: _feedbackController,
                        maxLines: null,
                        minLines: 5,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Ird ide a visszajelzésed...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _sendFeedback,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          backgroundColor: Colors.orangeAccent,
                          fixedSize: Size(200, 50),
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
