import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:saw/Page/HomePage.dart';
import 'package:saw/main.dart';

class DeactivateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()),
                    (route) => false);
              },
              icon: Icon(FontAwesomeIcons.arrowLeft)),
        ),
        body: DeactivateUserForm(),
      ),
    );
  }
}

class DeactivateUserForm extends StatefulWidget {
  @override
  _DeactivateUserFormState createState() => _DeactivateUserFormState();
}

class _DeactivateUserFormState extends State<DeactivateUserForm> {
  bool _isConfirmed = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
       await FirebaseAuth.instance.currentUser!.delete().then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                'images/assets/deactivateupdate.png', // Replace with your image path
                height: 200.0,
              ),
            ),
            Text(
              'Deactivate Account',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Are you sure you want to deactivate your account?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _isConfirmed = value!;
                    });
                  },
                ),
                Text(
                  'I understand that deactivating my account.',
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 12, left: 23),
              width: 280.0, // Adjust the width as per your requirement
              child: ElevatedButton(
                onPressed: _isConfirmed ? _confirmDeactivation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Set the background color to black
                  foregroundColor: Colors.white, // Set the text color to white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Set the button shape to rectangular
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0), // Adjust the vertical padding
                ),
                child: Text(
                  'Deactivate',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeactivation() {
    // Add your deactivate account logic here
    // For example, show a confirmation dialog or perform API request
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deactivation'),
        content: Text('Are you sure you want to deactivate your account?'),
        actions: [
          TextButton(
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
