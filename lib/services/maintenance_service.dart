import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/maintenance_request.dart';

class MaintenanceService {
  final dbHelper = DBHelper();

  Future<int> addRequest(MaintenanceRequest request) async {
    final db = await dbHelper.database;
    return await db.insert('maintenance_requests', request.toMap());
  }

  Future<List<MaintenanceRequest>> getAllRequests() async {
    final db = await dbHelper.database;
    final maps = await db.query('maintenance_requests');

    return maps.map((map) => MaintenanceRequest.fromMap(map)).toList();
  }

  Future<List<MaintenanceRequest>> getRequestByTenant(String tenantId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'maintenance_requests',
      where: 'tenantId = ?',
      whereArgs: [tenantId],
    );

    return maps.map((map) => MaintenanceRequest.fromMap(map)).toList();
  }

}