// import 'package:flutter/material.dart';
// import '../../../mongodb.dart';  // Ensure this import points to your MongoDB handler.
//
// class UserInputForm extends StatefulWidget {
//   const UserInputForm({Key? key}) : super(key: key);
//
//   @override
//   _UserInputFormState createState() => _UserInputFormState();
// }
//
// class _UserInputFormState extends State<UserInputForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Define variables to store form input values
//   String? firstName;
//   String? lastName;
//   String? phoneNumber;
//   String? aptNumber;
//   String? streetNumber;
//   String? cityName;
//   String? country;
//   String? postalCode;
//   String? packageType;
//
//   // Function to insert data into MongoDB
//   void insertData() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       // Create a document with the form data
//       var document = {
//         "first_name": firstName,
//         "last_name": lastName,
//         "phone_number": phoneNumber,
//         "apt_number": aptNumber,
//         "street_number": streetNumber,
//         "city_name": cityName,
//         "country": country,
//         "postal_code": postalCode,
//         "package_type": packageType,
//       };
//
//       // Call the MongoDB insert function
//       try {
//         await MongoDatabase.insertDocument(document);
//         // Display a success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Data inserted successfully')),
//         );
//       } catch (e) {
//         // Handle any errors that occur during the insertion
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to insert data: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // First Name
//             TextFormField(
//               decoration: InputDecoration(labelText: "First Name"),
//               onSaved: (value) => firstName = value,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter first name';
//                 }
//                 return null;
//               },
//             ),
//             // Last Name
//             TextFormField(
//               decoration: InputDecoration(labelText: "Last Name"),
//               onSaved: (value) => lastName = value,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter last name';
//                 }
//                 return null;
//               },
//             ),
//             // Phone Number
//             TextFormField(
//               decoration: InputDecoration(labelText: "Phone Number"),
//               keyboardType: TextInputType.phone, // Ensure only valid phone numbers are input
//               onSaved: (value) => phoneNumber = value,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter phone number';
//                 }
//                 return null;
//               },
//             ),
//             // Apartment Number
//             TextFormField(
//               decoration: InputDecoration(labelText: "Apartment Number"),
//               onSaved: (value) => aptNumber = value,
//             ),
//             // Street Number
//             TextFormField(
//               decoration: InputDecoration(labelText: "Street Number"),
//               onSaved: (value) => streetNumber = value,
//             ),
//             // City Name
//             TextFormField(
//               decoration: InputDecoration(labelText: "City Name"),
//               onSaved: (value) => cityName = value,
//             ),
//             // Country
//             TextFormField(
//               decoration: InputDecoration(labelText: "Country"),
//               onSaved: (value) => country = value,
//             ),
//             // Postal Code
//             TextFormField(
//               decoration: InputDecoration(labelText: "Postal Code"),
//               onSaved: (value) => postalCode = value,
//             ),
//             // Package Type Dropdown
//             DropdownButtonFormField<String>(
//               value: packageType,
//               hint: Text('Package Type'),
//               onChanged: (value) {
//                 setState(() {
//                   packageType = value;
//                 });
//               },
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please select a package type';
//                 }
//                 return null;
//               },
//               items: ['letter', 'heavy_package']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             // Submit Button
//             ElevatedButton(
//               onPressed: insertData,
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
