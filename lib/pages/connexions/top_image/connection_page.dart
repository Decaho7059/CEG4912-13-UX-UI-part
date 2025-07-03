import 'package:flutter/material.dart';
import 'package:mailboxapp_project/pages/connexions/top_image/sign_up_screen.dart';
import '../../../responsive.dart';
import '../../autres/background.dart';
import 'connection_top_screen.dart';
import 'login_screen.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool _isLoginScreen = true; // Controls whether login or signup is shown

  // This function toggles between the login and sign-up screens
  void toggleScreen() {
    setState(() {
      _isLoginScreen = !_isLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileConnectionScreen(
            isLoginScreen: _isLoginScreen,
            toggleScreen: toggleScreen,
          ),
          desktop: Row(
            children: [
              Expanded(
                child: ConnectionTopScreen(isLogin: _isLoginScreen),
              ),
              Expanded(
                child: _isLoginScreen
                    ? LoginScreen(toggleScreen: toggleScreen) // Pass toggleScreen to LoginScreen
                    : SignUpScreen(toggleScreen: toggleScreen), // Pass toggleScreen to SignUpScreen
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileConnectionScreen extends StatelessWidget {
  final bool isLoginScreen;
  final VoidCallback toggleScreen;

  const MobileConnectionScreen({
    Key? key,
    required this.isLoginScreen,
    required this.toggleScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ConnectionTopScreen(isLogin: isLoginScreen), // Display the top screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: isLoginScreen
              ? LoginScreen(toggleScreen: toggleScreen) // Show login form
              : SignUpScreen(toggleScreen: toggleScreen), // Show sign-up form
        ),
      ],
    );
  }
}