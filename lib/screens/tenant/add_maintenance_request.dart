import 'package:flutter/material.dart';
import '../../../models/maintenance_request.dart';
import '../../../services/maintenance_service.dart';

class AddMaintenanceRequestScreen extends StatefulWidget {
  const AddMaintenanceRequestScreen({super.key});

  @override
  State<AddMaintenanceRequestScreen> createState() => _AddMaintenanceRequestScreenState();
}

class _AddMaintenanceRequestScreenState extends State<AddMaintenanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _houseController = TextEditingController();
  final _issueController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final request = MaintenanceRequest(
        tenantId: 'dev_tenant_1',
        houseNumber: _houseController.text,
        issue: _issueController.text,
        status: 'Pending',
        dateReported: DateTime.now().toIso8601String(),
      );

      await MaintenanceService().addRequest(request);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Request submitted'),
      ));

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _houseController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Maintenance Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _houseController,
                decoration: const InputDecoration(labelText: 'House Number'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: _issueController,
                decoration: const InputDecoration(labelText: 'Describe the issue'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Submit'),
              )
            ],
          ),

        ),
      ),
    );
  }
















}