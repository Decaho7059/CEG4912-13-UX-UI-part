import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import '../../mongodb.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await MongoDatabase.getAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> _deleteUser(ObjectId id) async {
    try {
      await MongoDatabase.deleteUser(id.toHexString());
      _fetchUsers(); // Refresh the list
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  void _editUser(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(
        userData: userData,
        onSave: (updatedData) async {
          try {
            // Convert ObjectId to hex string before updating
            final id = userData['_id'] is ObjectId ? userData['_id'].toHexString() : userData['_id'];
            await MongoDatabase.updateUser(id, updatedData);
            _fetchUsers(); // Refresh the list after update
          } catch (e) {
            print("Error updating user: $e");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profiles')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                (user['firstName'] != null && user['firstName'].isNotEmpty)
                    ? user['firstName'][0]
                    : 'U',
              ),
            ),
            title: Text('${user['firstName']} ${user['lastName']}'),
            subtitle: Text(user['email'] ?? 'No Email'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editUser(context, user),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(user['_id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditUserDialog extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onSave;

  const EditUserDialog({Key? key, required this.userData, required this.onSave}) : super(key: key);

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
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
    _firstNameController.text = widget.userData['firstName'] ?? '';
    _lastNameController.text = widget.userData['lastName'] ?? '';
    _phoneNumberController.text = widget.userData['phoneNumber'] ?? '';
    _apartmentNumberController.text = widget.userData['aptNumber'] ?? '';
    _streetNumberController.text = widget.userData['streetNumber'] ?? '';
    _cityController.text = widget.userData['cityName'] ?? '';
    _countryController.text = widget.userData['country'] ?? '';
    _postalCodeController.text = widget.userData['postalCode'] ?? '';
    _packageTypeController.text = widget.userData['packageType'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
            TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
            TextField(controller: _phoneNumberController, decoration: const InputDecoration(labelText: 'Phone Number')),
            TextField(controller: _apartmentNumberController, decoration: const InputDecoration(labelText: 'Apartment Number')),
            TextField(controller: _streetNumberController, decoration: const InputDecoration(labelText: 'Street Number')),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
            TextField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country')),
            TextField(controller: _postalCodeController, decoration: const InputDecoration(labelText: 'Postal Code')),
            TextField(controller: _packageTypeController, decoration: const InputDecoration(labelText: 'Package Type')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave({
              'firstName': _firstNameController.text,
              'lastName': _lastNameController.text,
              'phoneNumber': _phoneNumberController.text,
              'aptNumber': _apartmentNumberController.text,
              'streetNumber': _streetNumberController.text,
              'cityName': _cityController.text,
              'country': _countryController.text,
              'postalCode': _postalCodeController.text,
              'packageType': _packageTypeController.text,
            });
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
