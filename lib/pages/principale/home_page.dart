import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mailboxapp_project/pages/autres/exit_app.dart';
import 'package:mailboxapp_project/pages/principale/profile_page.dart';
import 'package:sizer/sizer.dart';
import '../autres/background.dart';
import 'package:mailboxapp_project/constant.dart';
import 'messages_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  // List of pages for the navigation bar
  final List<Widget> _pages = [
    const WelcomeImage(), // Welcome page as home
    const MessagesPageScreen(),
    NotificationsPageScreen(), // Notification page
    MyProfileScreen(), // Profile page
    const ExitPage(), // Exit page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Background(
          child: _pages[_pageIndex], // Displays the current page based on the index
          key: ValueKey<int>(_pageIndex), // Key for animation
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: kPrimaryColor,
        color: Colors.lightGreen,
        items: <Widget>[
          const Icon(Icons.home, size: 26, color: Colors.white),

          // Wrap the message icon with a ValueListenableBuilder to show the unread message count
          ValueListenableBuilder(
            valueListenable: NotificationsPageScreen.unreadMessageCount,
            builder: (context, value, child) {
              return Stack(
                children: [
                  const Icon(Icons.message, size: 26, color: Colors.white),
                  if (value > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '$value',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const Icon(Icons.notifications, size: 26, color: Colors.white),
          const Icon(Icons.person, size: 26, color: Colors.white),
          const Icon(Icons.exit_to_app, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index; // Updates the selected page index
          });
        },
      ),
    );
  }
}

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out items
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the welcome text and new message
              children: [
                const Text(
                  "Welcome, to our MAILBOXAPP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                SvgPicture.asset(
                  "assets/icons/logo.svg",
                  width: 90.w, // Set a larger width
                  height: 50.h, // Set a larger height
                  fit: BoxFit.contain, // Adjust the image fit
                ),
                const SizedBox(height: defaultPadding * 2),
                const Text(
                  "Serving you is our priority, \nWelcome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
