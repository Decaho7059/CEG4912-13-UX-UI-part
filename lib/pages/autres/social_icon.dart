import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final VoidCallback press;

  const SocalIcon({
    Key? key,
    required this.iconSrc,  // Marked as required
    required this.press,     // Marked as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,  // Call the press function when the icon is tapped
      child: Container(
        width: 40,  // Set the width of the circle
        height: 40, // Set the height of the circle
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200, // Background color of the bubble
        ),
        child: Center(
          child: SvgPicture.asset(
            iconSrc, // Use iconSrc here
            width: 24, // Adjust size of the icon
            height: 24, // Adjust size of the icon
          ),
        ),
      ),
    );
  }
}
