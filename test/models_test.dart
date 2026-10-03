import 'package:flutter_test/flutter_test.dart';
import 'package:layanan_desa_cepoko/models.dart';

void main() {
  group('ComplaintStats', () {
    test('decodes database count values', () {
      final stats = ComplaintStats.fromJson(const {
        'total': 7,
        'processing': 3,
        'completed': 2,
      });
      expect(stats.total, 7);
      expect(stats.processing, 3);
      expect(stats.completed, 2);
    });

    test('handles null aggregate values without inventing data', () {
      final stats = ComplaintStats.fromJson(const {
        'total': null,
        'processing': null,
        'completed': null,
      });
      expect(stats.total, 0);
      expect(stats.processing, 0);
      expect(stats.completed, 0);
    });
  });

  test('public tracking response maps timestamps and redacted fields only', () {
    final result = ComplaintStatus.fromJson(const {
      'id': '2b84c0a1-9ba4-4db5-8ef5-2bff3201319e',
      'category': 'Infrastruktur',
      'title': 'Lampu jalan padam',
      'status': 'in_review',
      'created_at': '2026-10-02T03:00:00.000Z',
      'updated_at': '2026-10-02T04:00:00.000Z',
      'admin_note': 'Sedang ditinjau petugas.',
    });
    expect(result.status, 'in_review');
    expect(result.adminNote, 'Sedang ditinjau petugas.');
    expect(result.createdAt.toUtc().hour, 3);
  });
}
