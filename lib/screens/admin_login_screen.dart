import 'package:flutter/material.dart';
import 'add_apartment.dart';


import '../theme/app_colors.dart';class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final String _adminEmail = 'admin@admin.com';
  final String _adminPassword = 'admin123';

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == _adminEmail && password == _adminPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddApartmentScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: AppColors.dark),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.accent),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: AppColors.dark),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.accent),
                ),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
            )
          ],
        ),
      )
    );
  }
}