import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class MyProfileScreen extends StatefulWidget {
  final Map<String, String> userData;

  const MyProfileScreen({super.key, required this.userData});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isEditing = false;
  File? _profileImage;

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Row(
              children: [
                Icon(_isEditing ? Icons.save : Icons.edit),
                const SizedBox(width: 8),
                Text(_isEditing ? 'Save' : 'Edit'),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : const AssetImage('assets/images/log2.jpg') as ImageProvider,
            ),
            ProfileDetailRow(title: 'First Name', controller: _firstNameController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Last Name', controller: _lastNameController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Phone Number', controller: _phoneNumberController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Apartment Number', controller: _apartmentNumberController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Street Number', controller: _streetNumberController, isEditing: _isEditing),
            ProfileDetailRow(title: 'City', controller: _cityController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Country', controller: _countryController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Postal Code', controller: _postalCodeController, isEditing: _isEditing),
            ProfileDetailRow(title: 'Package Type', controller: _packageTypeController, isEditing: _isEditing),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isEditing;

  const ProfileDetailRow({Key? key, required this.title, required this.controller, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text('$title: '),
          isEditing
              ? Expanded(
            child: TextFormField(
              controller: controller,
            ),
          )
              : Text(controller.text),
        ],
      ),
    );
  }
}
