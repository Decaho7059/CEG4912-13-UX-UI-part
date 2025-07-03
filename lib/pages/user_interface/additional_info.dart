import 'package:flutter/material.dart';
import 'package:mailboxapp_project/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;


class AdditionalInfoScreen extends StatefulWidget {
  final String username;

  const AdditionalInfoScreen({Key? key, required this.username}) : super(key: key);

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _aptNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _packageTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDB();
  }

  Future<void> _initializeDB() async {
    try {
      await MongoDatabase.connectAdditionalInfoDB();
      print("Additional Info DB connected successfully");

      // Vérifier si des informations existent déjà
      final existingInfo = await MongoDatabase.getAdditionalInfoByUsername(widget.username);
      if (existingInfo != null) {
        setState(() {
          _firstNameController.text = existingInfo['firstName'] ?? '';
          _lastNameController.text = existingInfo['lastName'] ?? '';
          _phoneNumberController.text = existingInfo['phoneNumber'] ?? '';
          _aptNumberController.text = existingInfo['aptNumber'] ?? '';
          _streetNumberController.text = existingInfo['streetNumber'] ?? '';
          _cityNameController.text = existingInfo['cityName'] ?? '';
          _countryController.text = existingInfo['country'] ?? '';
          _postalCodeController.text = existingInfo['postalCode'] ?? '';
          _packageTypeController.text = existingInfo['packageType'] ?? '';
        });
      }
    } catch (e) {
      print("Error during DB connection: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion à la base de données")),
      );
    }
  }


  void _saveAdditionalInfo() async {
    bool infoExists = await MongoDatabase.checkAdditionalInfoExists(widget.username);

    if (infoExists) {
      // Charger les informations existantes depuis MongoDB
      final existingInfo = await MongoDatabase.getAdditionalInfoByUsername(widget.username);
      if (existingInfo != null) {
        setState(() {
          _firstNameController.text = existingInfo['firstName'] ?? '';
          _lastNameController.text = existingInfo['lastName'] ?? '';
          _phoneNumberController.text = existingInfo['phoneNumber'] ?? '';
          _aptNumberController.text = existingInfo['aptNumber'] ?? '';
          _streetNumberController.text = existingInfo['streetNumber'] ?? '';
          _cityNameController.text = existingInfo['cityName'] ?? '';
          _countryController.text = existingInfo['country'] ?? '';
          _postalCodeController.text = existingInfo['postalCode'] ?? '';
          _packageTypeController.text = existingInfo['packageType'] ?? '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Information already exists for this user.")),
        );
      }
      return;
    }

    // Sauvegarde des nouvelles informations
    Map<String, dynamic> additionalInfo = {
      '_id': ObjectId(), // Génération d'un nouvel ObjectId
      'username': widget.username,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'aptNumber': _aptNumberController.text,
      'streetNumber': _streetNumberController.text,
      'cityName': _cityNameController.text,
      'country': _countryController.text,
      'postalCode': _postalCodeController.text,
      'packageType': _packageTypeController.text,
    };

    try {
      await MongoDatabase.upsertAdditionalInfo(additionalInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informations sauvegardées avec succès !")),
      );

      // Exit to a specific page after success
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
              (Route<dynamic> route) => false, // Supprime toutes les routes précédentes
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Additional Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _aptNumberController,
                decoration: const InputDecoration(labelText: 'Apartment Number'),
              ),
              TextField(
                controller: _streetNumberController,
                decoration: const InputDecoration(labelText: 'Street Number'),
              ),
              TextField(
                controller: _cityNameController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Postal Code'),
              ),
              TextField(
                controller: _packageTypeController,
                decoration: const InputDecoration(labelText: 'Package Type'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAdditionalInfo,
                child: const Text("Save Information"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
