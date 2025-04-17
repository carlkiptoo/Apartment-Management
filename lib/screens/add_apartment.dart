import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AddApartmentScreen extends StatelessWidget {
  const AddApartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Apartment")),
      body: const Center(
        child: Text(
          'Welcome to the Add Apartment screen!',
          style: TextStyle(fontSize: 18, color: AppColors.dark),
        ),
      ),
    );
  }
}
