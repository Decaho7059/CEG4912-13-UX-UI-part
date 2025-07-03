import 'package:flutter/material.dart';
import '../../../mongodb.dart';
import 'connection_form.dart';
import '../../user_interface/additional_info.dart';
import '../../../constant.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback toggleScreen;

  const LoginScreen({Key? key, required this.toggleScreen}) : super(key: key);

  Future<void> _handleLogin(BuildContext context, String username, String role) async {
    if (role == 'Admin') {
      // Navigate to the admin home screen if the role is 'Admin'
      Navigator.pushReplacementNamed(context, '/home');
    } else if (role == 'Utilisateur') {
      // Navigate to the user home screen if additional information exists
      //Navigator.pushReplacementNamed(context, '/_user_Home');
      //Check if additional information exists for a regular user
      bool additionalInfoExists = await checkIfAdditionalInfoExists(username);
      if (additionalInfoExists) {
        // Navigate to the user home screen if additional information exists
        Navigator.pushNamed(context, '/user_Home');
      } else {
        // If additional info does not exist, navigate to AdditionalInfoScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdditionalInfoScreen(username: username)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid role. Please contact support.")),
      );
    }
  }

  Future<bool> checkIfAdditionalInfoExists(String username) async {
    // Logic to verify if additional information exists in MongoDB
    return await MongoDatabase.checkAdditionalInfoExists(username);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 450,
            child: ConnectionForm(
              isLogin: true,
              onLoginSuccess: (username, role) => _handleLogin(context, username, role),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          TextButton(
            onPressed: toggleScreen,
            child: const Text("Don't have an account? Sign Up"),
          ),
        ],
      ),
    );
  }
}
