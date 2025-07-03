import 'package:flutter/material.dart';
import '../autres/track_letter.dart';

class NotificationsPageScreen extends StatelessWidget {
  static ValueNotifier<int> unreadMessageCount = ValueNotifier<int>(0);

  // void initializeNotifications() {
  //   AwesomeNotifications().initialize(
  //     null,
  //     [
  //       NotificationChannel(
  //         channelKey: 'basic_channel',
  //         channelName: 'Basic Notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //       ),
  //     ],
  //     debug: true,
  //   );
  //
  //   AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //     if (!isAllowed) {
  //       AwesomeNotifications().requestPermissionToSendNotifications();
  //     }
  //   });
  // }
  //
  // void triggerNotification() {
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 10,
  //       channelKey: 'basic_channel',
  //       title: 'New Message',
  //       body: 'You have received a new message',
  //     ),
  //   );
  //
  //   unreadMessageCount.value++;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              //triggerNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification Triggered')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mess_notif/not3.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Text(
                    'No notification received',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrackMyLetterScreen()),
                    );
                  },
                  child: const Text("Track My Letter"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
