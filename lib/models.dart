class ComplaintStats {
  const ComplaintStats({
    required this.total,
    required this.processing,
    required this.completed,
  });

  final int total;
  final int processing;
  final int completed;

  factory ComplaintStats.fromJson(Map<String, dynamic> json) => ComplaintStats(
    total: (json['total'] as num?)?.toInt() ?? 0,
    processing: (json['processing'] as num?)?.toInt() ?? 0,
    completed: (json['completed'] as num?)?.toInt() ?? 0,
  );
}

class ComplaintStatus {
  const ComplaintStatus({
    required this.id,
    required this.category,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.adminNote,
  });

  final String id;
  final String category;
  final String title;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? adminNote;

  factory ComplaintStatus.fromJson(Map<String, dynamic> json) =>
      ComplaintStatus(
        id: json['id'] as String,
        category: json['category'] as String,
        title: json['title'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
        updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
        adminNote: json['admin_note'] as String?,
      );
}

class ReportReceipt {
  const ReportReceipt({required this.id, required this.status});
  final String id;
  final String status;
}

class AdminComplaint {
  const AdminComplaint({
    required this.id,
    required this.name,
    required this.neighbourhood,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.contact,
    this.adminNote,
    this.attachmentName,
  });

  final String id;
  final String name;
  final String neighbourhood;
  final String category;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;
  final String? contact;
  final String? adminNote;
  final String? attachmentName;

  factory AdminComplaint.fromJson(Map<String, dynamic> json) => AdminComplaint(
    id: json['id'] as String,
    name: json['full_name'] as String,
    neighbourhood: json['neighbourhood'] as String,
    category: json['category'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    status: json['status'] as String,
    createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    contact: json['contact'] as String?,
    adminNote: json['admin_note'] as String?,
    attachmentName: json['attachment_name'] as String?,
  );
}
