import 'package:flutter/material.dart';
import 'dart:io';

class ExitPage extends StatelessWidget {
  const ExitPage({Key? key}) : super(key: key);

  // Function to show a confirmation dialog before exiting the app
  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit App"),
          content: Text("Are you sure you want to exit the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                exit(0); // Exit the app
              },
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exit App'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'About Us',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Thank you for using our app. We strive to provide the best possible service and appreciate your support. Continue to trust us to meet your needs.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              'Thank you for your trust!',
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => _handleLogout(context),
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () => _showExitConfirmation(context),
              child: Text('Quit the application'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
