import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'apartment_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  bool _loading = false;

  // Future<void>  _login() async {
  //
  //   final email = _emailController.text.trim();
  //   final password = _passwordController.text.trim();
  //   final url = Uri.parse('http://192.168.100.6:5000/api/auth/login');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({'email': email, 'password': password});
  //
  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       print('Login success');
  //     } else {
  //       print('Login failed ${response.body}');
  //     }
  //
  //   } catch (e) {
  //     print('Error: ${e}');
  //   }
  // }

  Future<void> _login() async {

    setState(() {
      _loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final url = Uri.parse('http://192.168.100.6:5000/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Status code: ${response.statusCode}');
        if (response.headers['content-type']?.contains('application/json') ?? false){
          final data = jsonDecode(response.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('token', data['token']);
          await prefs.setString('userRole', data['user']['role']);
          // await prefs.setString('userId', data['user']['_id']);
        } else {
          print('Response is not in JSON: ${response.body}');
        }



        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ApartmentListScreen()),
          );
        }
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
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
            _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _login, child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
