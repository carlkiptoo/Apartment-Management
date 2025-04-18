import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final List<String> _houseTypes = [
    'Studio Apt',
    '1 Bedroom',
    '2 Bedrooms',
    '3 Bedrooms',
    '4 Bedrooms',
  ];

  String? _selectedHouseType;

  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _houseTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _houseNumberController = TextEditingController();
  File? _passportImage;
  // User should submit passport image

  bool _loading = false;

  Future<void> _pickPassportImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _passportImage = File(pickedFile.path);
      });
    }
  }
  Future<void> _submitApartment() async {
    final name = _nameController.text.trim();
    final idNumber = _idNumberController.text.trim();
    late String houseType = _houseTypeController.text.trim();
    final houseNumber = _houseNumberController.text.trim();
    final priceText = _priceController.text.trim();

    //Validation
    if (name.isEmpty ||
        idNumber.isEmpty ||
        priceText.isEmpty ||
        houseNumber.isEmpty ||
        _selectedHouseType == null ||
        _passportImage == null
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    final apartment = {
      "name": _nameController.text,
      "idNumber": _idNumberController.text,
      "houseType": _selectedHouseType,
      "houseNumber": _houseNumberController.text,
      "price": double.tryParse(_priceController.text) ?? 0.0,
      "passportImage": _passportImage!.path,
    };
    setState(() {
      _loading = true;
    });
    try {
      await DBHelper().insertApartment(apartment);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apartment Saved Successfully')),
      );
      Navigator.pop(context, true);
      _nameController.clear();
      _idNumberController.clear();
      _houseTypeController.clear();
      _houseNumberController.clear();
      _priceController.clear();
      setState(() {
        _selectedHouseType = null;
        _passportImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      print('Error $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Apartment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // name input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _idNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID number',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            //location input
            DropdownButtonFormField<String>(
              value: _selectedHouseType,
              decoration: InputDecoration(
                labelText: 'House Type',
                labelStyle: TextStyle(color: AppColors.dark),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items:
                  _houseTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedHouseType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(color: AppColors.dark),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              onPressed: _pickPassportImage,
              label: const Text('Capture passport image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            if (_passportImage != null)
              Image.file(
                _passportImage!,
                height: 150,
              ),

            TextField(
              controller: _houseNumberController,
              decoration: InputDecoration(
                labelText: 'House Number',
                labelStyle: const TextStyle(color: AppColors.dark),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitApartment,
                  child: const Text(
                    'Save Apartment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
