import 'package:flutter/material.dart';
import 'package:mailboxapp_project/pages/autres/exit_app.dart';
import 'package:mailboxapp_project/pages/autres/firebase_api.dart';
import 'package:mailboxapp_project/pages/connexions/top_image/connection_page.dart';
import 'package:mailboxapp_project/pages/principale/home_page.dart';
import 'package:mailboxapp_project/pages/principale/notifications_page.dart';
import 'package:mailboxapp_project/pages/user_interface/user_interface.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'mongodb.dart';

// Import Firebase packages
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();


  // Connect to MongoDB databases
  try {
    await MongoDatabase.connectMainDB();
    print("Main database connection established successfully.");

    await MongoDatabase.connectAdditionalInfoDB();
    print("Additional info database connection established successfully.");
  } catch (e) {
    print("Failed to connect to one or both databases: $e");
  }

  // Launch the application
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ConnectionScreen(), // Changed to match the screenshot
      routes: {
        '/home': (context) => const HomePage(),
        '/user_Home': (context) => const UserInterface(),
        '/quit': (context) => const ExitPage(),
        '/login': (context) => ConnectionScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
