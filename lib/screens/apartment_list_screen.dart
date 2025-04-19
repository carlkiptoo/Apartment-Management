import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../theme/app_colors.dart';
import 'add_apartment.dart';
import 'dart:io';
import 'admin_login_screen.dart';

class ApartmentListScreen extends StatefulWidget {
  const ApartmentListScreen({super.key});

  @override
  State<ApartmentListScreen> createState() => _ApartmentListScreenState();
}

class _ApartmentListScreenState extends State<ApartmentListScreen> {
  List<Map<String, dynamic>> _apartments= [];

  @override
  void initState() {
    super.initState();
    _loadApartments();
  }

  Future<void> _loadApartments() async {
    final data = await DBHelper().getApartments();
    setState(() {
      _apartments = data;
    });
  }

  void _goToAddApartmentScreen() async {
    final result = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => const AddApartmentScreen()),
    );
    if (result == true) {
      _loadApartments();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen()),
          (route) => false,
      );

  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Rental List'),
          actions: [
            IconButton(onPressed: _logout,
              icon: const Icon(Icons.logout),
            )
          ],
        ),

        body: _apartments.isEmpty
            ? const Center(child: Text('No rentals yet'))
            : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: _apartments.length,
          itemBuilder: (context, index){
            final apartment = _apartments[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: apartment['passportImage'] != null
                    ? CircleAvatar(
                  backgroundImage: FileImage(File(apartment['passportImage'])),
                )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(apartment['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${apartment['idNumber']}'),
                    Text('Type: ${apartment['houseType']}'),
                    Text('House: ${apartment['houseNumber']}'),
                    Text('Price: ${apartment['price']}'),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: _goToAddApartmentScreen,
              child: const Icon(Icons.add),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
      );

  }



}
