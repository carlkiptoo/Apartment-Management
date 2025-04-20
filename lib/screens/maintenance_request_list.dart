import 'package:apartment_management/models/maintenance_request.dart';
import 'package:flutter/material.dart';
import '../../../services/maintenance_service.dart';

class MaintenanceRequestListScreen extends StatefulWidget {
  const MaintenanceRequestListScreen({super.key});

  @override
  State<MaintenanceRequestListScreen> createState() => _MaintenanceRequestListScreenState();

}

class _MaintenanceRequestListScreenState extends State<MaintenanceRequestListScreen> {
  List<MaintenanceRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final requests = await MaintenanceService().getAllRequests();
    setState(() {
      _requests = requests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Requests')),
      body: _requests.isEmpty
      ? const Center(child: Text('No maintenance requests yet'))
      : ListView.builder(
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final req = _requests[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text('Issue: ${req.issue}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('House: ${req.houseNumber}'),
                  Text('Status: ${req.status}'),
                  Text('Date: ${req.dateReported}'),
                ],
              ),
              trailing: req.status == 'Pending'
              ? IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () async {
                  await MaintenanceService().updateRequestStatus(req.tenantId as int, req.status);
                  _loadRequests();
                },
              )
                  : const Icon(Icons.check_circle, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}