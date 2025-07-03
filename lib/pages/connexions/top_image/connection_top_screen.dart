import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailboxapp_project/constant.dart';

class ConnectionTopScreen extends StatelessWidget {
  final bool isLogin; // To determine if the screen is for login or signup

  const ConnectionTopScreen({
    super.key,
    required this.isLogin, // Required parameter to determine the screen type
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isLogin ? "LOGIN" : "SIGN UP", // Display title based on the screen type
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                isLogin ? "assets/icons/login.svg" : "assets/icons/signup.svg", // Load the appropriate SVG
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
