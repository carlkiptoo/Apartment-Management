class MaintenanceRequest {
  final int? id;
  final String tenantId;
  final String houseNumber;
  final String issue;
  final String status;
  final String? imagePath;
  final String? adminNotes;
  final String dateReported;
  final String? dateResolved;
  
  MaintenanceRequest({
    this.id,
    required this.tenantId,
    required this.houseNumber,
    required this.issue,
    required this.status,
    this.imagePath,
    this.adminNotes,
    required this.dateReported,
    this.dateResolved,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenantId': tenantId,
      'houseNumber': houseNumber,
      'issue': issue,
      'status': status,
      'imagePath': imagePath,
      'adminNotes': adminNotes,
      'dateReported': dateReported,
      'dateResolved': dateResolved,
    };
  }

  static MaintenanceRequest fromMap(Map<String, dynamic> map) {
    return MaintenanceRequest(
      id: map['id'],
      tenantId: map['tenantId'],
      houseNumber: map['houseNumber'],
      issue: map['issue'],
      status: map['status'],
      imagePath: map['imagePath'],
      adminNotes: map['adminNotes'],
      dateReported: map['dateReported'],
      dateResolved: map['dateResolved'],
    );
  }
}