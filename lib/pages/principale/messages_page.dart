import 'package:flutter/material.dart';
import 'package:mailboxapp_project/constant.dart';
import 'notifications_page.dart';

class MessagesPageScreen extends StatefulWidget {
  const MessagesPageScreen({Key? key}) : super(key: key);

  @override
  _MessagesPageScreenState createState() => _MessagesPageScreenState();
}

class _MessagesPageScreenState extends State<MessagesPageScreen> {
  @override
  void initState() {
    super.initState();

    // Utilisez WidgetsBinding.instance.addPostFrameCallback pour éviter l'erreur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationsPageScreen.unreadMessageCount.value = 0; // Réinitialiser le compteur après la construction
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mess_notif/mess1.jpg'),
            fit: BoxFit.cover, // Make the image cover the entire background
            alignment: Alignment.bottomCenter, // Center the image
          ),
        ),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: NotificationsPageScreen.unreadMessageCount,
            builder: (context, value, child) {

              // Displays text based on the number of unread messages
              return Text(
                value > 1
                    ? 'You have $value unread messages'
                    : value == 1
                    ? 'You have $value unread messages'
                    : 'No unread messages',
                style: const TextStyle(
                  fontSize: 24,
                  color: kPrimaryColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
