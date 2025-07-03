import 'package:flutter/material.dart';
import 'package:mailboxapp_project/mongodb.dart';
import '../../../constant.dart';
import '../../user_interface/additional_info.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleScreen;

  const SignUpScreen({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  final List<String> _roles = ['Utilisateur', 'Admin'];

  void _completeSignUp(BuildContext context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be completed.")),
      );
      return;
    }

    Map<String, dynamic> userData = {
      'username': username,
      'email': email,
      'password': password,
      'role': _selectedRole,
    };

    try {
      await MongoDatabase.insertDocument(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful!")),
      );

      // Vérifiez si le rôle est "Utilisateur" pour naviguer vers la page des informations supplémentaires
      if (_selectedRole == 'Utilisateur') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdditionalInfoScreen(username: username)),
        );
      } else {
        widget.toggleScreen(); // Retournez à l'écran de connexion pour un rôle "Admin"
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'User name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding * 0.5),
            ElevatedButton(
              onPressed: () {
                _completeSignUp(context);
              },
              child: const Text('Register'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: defaultPadding * 0.5),
            TextButton(
              onPressed: widget.toggleScreen,
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
