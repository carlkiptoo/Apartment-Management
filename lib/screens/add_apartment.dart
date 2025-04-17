import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();

}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _loading = false;

  Future<void> _submitApartment() async {
    final apartment = {
      "name": _nameController.text,
      "location": _locationController.text,
      "price": double.tryParse(_priceController.text) ?? 0.0,
      "imageUrl": _imageUrlController.text,
      "description": _descriptionController.text,
    };

    setState(() {
      _loading = true;
    });

    try {
      await DBHelper().insertApartment(apartment);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apartment Saved Successfully')),
      );
      _nameController.clear();
      _locationController.clear();
      _priceController.clear();
      _imageUrlController.clear();
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

}