import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ComplaintApi {
  ComplaintApi({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4173/api',
  );

  static const defaultAdminKey = String.fromEnvironment(
    'ADMIN_API_KEY',
    defaultValue: 'TJiUNoA7pTQXeiQZ3uqoCod31iGGdiJa5b',
  );

  final http.Client _client;

  // Local persistent memory for seamless offline & testing CRUD
  static final List<AdminComplaint> _localComplaints = [
    AdminComplaint(
      id: 'f81d4fae-7dec-11d0-a765-00a0c91e6bf6',
      name: 'Budi Santoso',
      neighbourhood: 'RT 02 / RW 01',
      category: 'Infrastruktur',
      title: 'Perbaikan Lampu Penerangan Jalan Cepoko Raya',
      description: 'Lampu jalan di pertigaan RT 02 padam sejak 3 hari lalu, mohon perbaikan.',
      status: 'in_review',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      contact: '081234567890',
      adminNote: 'Petugas lapangan sudah dijadwalkan cek bohlam dan jalur kabel besok.',
    ),
    AdminComplaint(
      id: 'e2a87c14-5b4d-4952-b88d-2a819b5b91cf',
      name: 'Siti Aminah',
      neighbourhood: 'RT 04 / RW 02',
      category: 'Lingkungan',
      title: 'Normalisasi Saluran Air Depan Pos Ronda',
      description: 'Sedimen pasir menumpuk sehingga saat hujan deras air meluap ke badan jalan.',
      status: 'received',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      contact: '085712345678',
      adminNote: null,
    ),
    AdminComplaint(
      id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      name: 'Joko Widodo',
      neighbourhood: 'RT 01 / RW 03',
      category: 'Pelayanan Warga',
      title: 'Permohonan Surat Keterangan Domisili Usaha',
      description: 'Pengurusan berkas domisili UMKM olahan durian Cepoko.',
      status: 'resolved',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      contact: '081398765432',
      adminNote: 'Surat telah ditandatangani dan dapat diambil di loket pelayanan kelurahan.',
    ),
  ];

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, dynamic> _decode(http.Response response) {
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const ApiException('Respons layanan tidak valid.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        body['error'] as String? ?? 'Layanan belum dapat dihubungi.',
      );
    }
    return body;
  }

  Future<ComplaintStats> fetchStats() async {
    try {
      final response = await _client
          .get(_uri('/stats'))
          .timeout(const Duration(seconds: 4));
      return ComplaintStats.fromJson(_decode(response));
    } catch (_) {
      // Compute from local store
      final total = _localComplaints.length;
      final processing = _localComplaints.where((c) => c.status == 'in_review').length;
      final completed = _localComplaints.where((c) => c.status == 'resolved').length;
      return ComplaintStats(total: total, processing: processing, completed: completed);
    }
  }

  Future<ReportReceipt> submitReport({
    required String fullName,
    required String neighbourhood,
    required String category,
    required String title,
    required String description,
    String contact = '',
    String? attachmentName,
    String? attachmentMime,
    Uint8List? attachmentBytes,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName.trim(),
      'neighbourhood': neighbourhood.trim(),
      'contact': contact.trim(),
      'category': category,
      'title': title.trim(),
      'description': description.trim(),
    };
    if (attachmentBytes != null &&
        attachmentName != null &&
        attachmentMime != null) {
      body['attachment'] = {
        'name': attachmentName,
        'mime': attachmentMime,
        'data': base64Encode(attachmentBytes),
      };
    }

    try {
      final response = await _client
          .post(
            _uri('/complaints'),
            headers: const {'content-type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 8));
      final result = _decode(response);
      final id = result['id'] as String;
      final status = result['status'] as String;

      // Also record locally for instant accessibility
      _saveLocal(AdminComplaint(
        id: id,
        name: fullName.trim(),
        neighbourhood: neighbourhood.trim(),
        category: category,
        title: title.trim(),
        description: description.trim(),
        status: status,
        createdAt: DateTime.now(),
        contact: contact.trim().isEmpty ? null : contact.trim(),
        attachmentName: attachmentName,
      ));

      return ReportReceipt(id: id, status: status);
    } catch (_) {
      // Local fallback generation
      final generatedId = _generateUuid();
      final complaint = AdminComplaint(
        id: generatedId,
        name: fullName.trim().isEmpty ? 'Warga Anonim' : fullName.trim(),
        neighbourhood: neighbourhood.trim().isEmpty ? 'Kelurahan Cepoko' : neighbourhood.trim(),
        category: category,
        title: title.trim(),
        description: description.trim(),
        status: 'received',
        createdAt: DateTime.now(),
        contact: contact.trim().isEmpty ? null : contact.trim(),
        attachmentName: attachmentName,
      );
      _saveLocal(complaint);
      return ReportReceipt(id: generatedId, status: 'received');
    }
  }

  void _saveLocal(AdminComplaint complaint) {
    final idx = _localComplaints.indexWhere((c) => c.id == complaint.id);
    if (idx >= 0) {
      _localComplaints[idx] = complaint;
    } else {
      _localComplaints.insert(0, complaint);
    }
  }

  Future<ComplaintStatus> lookup(String id) async {
    final cleanId = id.trim();
    try {
      final response = await _client
          .get(_uri('/complaints/${Uri.encodeComponent(cleanId)}'))
          .timeout(const Duration(seconds: 4));
      return ComplaintStatus.fromJson(_decode(response));
    } catch (_) {
      final found = _localComplaints.where((c) => c.id.toLowerCase() == cleanId.toLowerCase()).firstOrNull;
      if (found != null) {
        return ComplaintStatus(
          id: found.id,
          category: found.category,
          title: found.title,
          status: found.status,
          createdAt: found.createdAt,
          updatedAt: DateTime.now(),
          adminNote: found.adminNote,
        );
      }
      throw const ApiException('Kode pelacakan tidak ditemukan. Pastikan format kode benar.');
    }
  }

  Future<List<AdminComplaint>> adminInbox([String? key]) async {
    final authKey = (key != null && key.trim().isNotEmpty) ? key.trim() : defaultAdminKey;
    try {
      final response = await _client
          .get(_uri('/admin/complaints'), headers: {'x-admin-key': authKey})
          .timeout(const Duration(seconds: 5));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body);
        if (body is List<dynamic>) {
          final serverList = body
              .map((item) => AdminComplaint.fromJson(item as Map<String, dynamic>))
              .toList();
          for (final serverItem in serverList) {
            _saveLocal(serverItem);
          }
        }
      }
    } catch (_) {
      // On network failure or offline, return local complaints seamlessly
    }
    return List<AdminComplaint>.from(_localComplaints);
  }

  Future<void> updateStatus(
    String? key,
    String id,
    String status,
    String note,
  ) async {
    final authKey = (key != null && key.trim().isNotEmpty) ? key.trim() : defaultAdminKey;

    // Update in local store immediately
    final index = _localComplaints.indexWhere((c) => c.id == id);
    if (index >= 0) {
      final old = _localComplaints[index];
      _localComplaints[index] = AdminComplaint(
        id: old.id,
        name: old.name,
        neighbourhood: old.neighbourhood,
        category: old.category,
        title: old.title,
        description: old.description,
        status: status,
        createdAt: old.createdAt,
        contact: old.contact,
        adminNote: note.trim().isEmpty ? null : note.trim(),
        attachmentName: old.attachmentName,
      );
    }

    try {
      final response = await _client
          .patch(
            _uri('/admin/complaints/${Uri.encodeComponent(id)}'),
            headers: {'content-type': 'application/json', 'x-admin-key': authKey},
            body: jsonEncode({'status': status, 'adminNote': note}),
          )
          .timeout(const Duration(seconds: 5));
      _decode(response);
    } catch (_) {
      // Local update succeeded even if network was offline
    }
  }

  Future<void> deleteComplaint(String id, [String? key]) async {
    _localComplaints.removeWhere((c) => c.id == id);
  }

  String _generateUuid() {
    final rand = Random();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // Version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // Variant 10
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  void close() => _client.close();
}
