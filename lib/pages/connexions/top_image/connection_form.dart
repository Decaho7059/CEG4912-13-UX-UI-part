import 'package:flutter/material.dart';
import 'package:mailboxapp_project/mongodb.dart';

class ConnectionForm extends StatefulWidget {
  final bool isLogin;
  final Future<void> Function(String username, String role) onLoginSuccess;

  const ConnectionForm({Key? key, required this.isLogin, required this.onLoginSuccess}) : super(key: key);

  @override
  _ConnectionFormState createState() => _ConnectionFormState();
}

class _ConnectionFormState extends State<ConnectionForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedRole;
  final List<String> _roles = ['Utilisateur', 'Admin'];

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (widget.isLogin) {
      try {
        var user = await MongoDatabase.getUserByEmail(email);
        if (user != null && user['password'] == password) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful!")),
          );
          await widget.onLoginSuccess(user['username'], user['role']); // Pass both username and role
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      }
    } else {
      String username = _usernameController.text.trim();
      try {
        if (_selectedRole == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a role.")),
          );
          return;
        }

        Map<String, dynamic> userData = {
          'username': username,
          'email': email,
          'password': password,
          'role': _selectedRole,
        };

        await MongoDatabase.insertDocument(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-up successful! Please login.")),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-up failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!widget.isLogin)
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username", hintText: "Enter your username"),
              validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
            ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email", hintText: "Enter your email"),
            validator: (value) => value == null || value.isEmpty ? 'Email is required' : null,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password", hintText: "Enter your password"),
            validator: (value) => value == null || value.length < 4 ? 'Password should be at least 4 characters' : null,
          ),
          if (!widget.isLogin)
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _handleSubmit(context),
            child: Text(widget.isLogin ? "Login" : "Sign Up"),
          ),
        ],
      ),
    );
  }
}
