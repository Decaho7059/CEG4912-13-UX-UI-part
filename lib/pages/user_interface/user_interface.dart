import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mailboxapp_project/pages/autres/exit_app.dart';
import 'package:mailboxapp_project/pages/principale/notifications_page.dart';
import 'package:mailboxapp_project/constant.dart';
import '../autres/background.dart';
import '../../mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'additional_info.dart';
import '../principale/home_page.dart';

class UserInterface extends StatefulWidget {
  const UserInterface({Key? key}) : super(key: key);

  @override
  State<UserInterface> createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  int _pageIndex = 0;
  String? _userEmail; // Stocke l'email récupéré

  @override
  void initState() {
    super.initState();
    _fetchUserEmail(); // Récupérer l'email lors de l'initialisation
  }


  Future<void> _fetchUserEmail() async {
    try {
      print("Fetching user email...");
      final user = await MongoDatabase.getUserByEmail("charliebrown@gmail.com");
      if (user != null) {
        print("User email retrieved: ${user['email']}");
        setState(() {
          _userEmail = user['email'];
        });
      } else {
        print("No user found with the provided default email.");
      }
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    // Passer l'email uniquement si récupéré
    final List<Widget> pages = [
      const WelcomeImage(),
      NotificationsPageScreen(),
      _userEmail != null
          ? MyProfileScreen(email: _userEmail!)
          : const Center(child: CircularProgressIndicator()), // Chargement
      const ExitPage(),
    ];


    return Scaffold(
      body: Background(
        child: pages[_pageIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.lightGreen,
        color: kPrimaryColor,
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.notifications, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
          Icon(Icons.exit_to_app, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}


class MyProfileScreen extends StatefulWidget {
  final String email;

  const MyProfileScreen({required this.email});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isEditing = false;
  bool _isExpanded = false;
  Map<String, dynamic> _userData = {};

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _apartmentNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _packageTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_userData.isNotEmpty) return; // Éviter un nouvel appel si les données sont déjà chargées.

    print("Attempting to retrieve user with email: ${widget.email}");
    final user = await MongoDatabase.getUserByEmail(widget.email);

    if (user != null) {
      // Charger les informations utilisateur principales
      setState(() {
        _userData = user;
        _firstNameController.text = user['firstName'] ?? '';
        _lastNameController.text = user['lastName'] ?? '';
      });

      // Charger les informations additionnelles si elles existent
      final additionalInfo = await MongoDatabase.getAdditionalInfoByUsername(user['username']);
      if (additionalInfo != null) {
        setState(() {
          _phoneNumberController.text = additionalInfo['phoneNumber'] ?? '';
          _apartmentNumberController.text = additionalInfo['aptNumber'] ?? '';
          _streetNumberController.text = additionalInfo['streetNumber'] ?? '';
          _cityController.text = additionalInfo['cityName'] ?? '';
          _countryController.text = additionalInfo['country'] ?? '';
          _postalCodeController.text = additionalInfo['postalCode'] ?? '';
          _packageTypeController.text = additionalInfo['packageType'] ?? '';
        });
        print("Loaded additional information for user: ${user['username']}");
      } else {
        print("No additional information found for user: ${user['username']}");
      }
    } else {
      print("Error: No user found with the provided email.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user found with the provided email.")),
      );
    }
  }


  Future<void> _saveUserData() async {
    if (_userData['_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User ID is missing.")),
      );
      return;
    }

    final userId = (_userData['_id'] is mongo.ObjectId)
        ? (_userData['_id'] as mongo.ObjectId).toHexString()
        : _userData['_id'].toString();

    final updatedData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'aptNumber': _apartmentNumberController.text,
      'streetNumber': _streetNumberController.text,
      'cityName': _cityController.text,
      'country': _countryController.text,
      'postalCode': _postalCodeController.text,
      'packageType': _packageTypeController.text,
    };

    try {
      await MongoDatabase.updateUser(userId, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                final confirm = await _showConfirmationDialog();
                if (confirm) {
                  _saveUserData();
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16.0),
              _buildExpandableDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("assets/images/user1.jpg"), // Placeholder image
        ),
        const SizedBox(height: 10),
        Text(
          "${_firstNameController.text} ${_lastNameController.text}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          widget.email,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildExpandableDetails() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text(
                "Additional Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildProfileField('Phone Number', _phoneNumberController),
                _buildProfileField('Apartment Number', _apartmentNumberController),
                _buildProfileField('Street Number', _streetNumberController),
                _buildProfileField('City', _cityController),
                _buildProfileField('Country', _countryController),
                _buildProfileField('Postal Code', _postalCodeController),
                _buildProfileField('Package Type', _packageTypeController),
              ],
            ),
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }


  Widget _buildProfileField(String label, TextEditingController controller, {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: '),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: isReadOnly || !_isEditing,
              // decoration: InputDecoration(
              //   border: isReadOnly ? InputBorder.none : const OutlineInputBorder(),
              // ),
            ),
          ),
        ],
      ),
    );
  }



  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Update"),
        content: const Text("Are you sure you want to save these changes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    ) ??
        false;
  }
}
