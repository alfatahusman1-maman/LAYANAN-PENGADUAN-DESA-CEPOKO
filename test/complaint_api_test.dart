import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:layanan_desa_cepoko/data/complaint_api.dart';

void main() {
  test(
    'tracking translates a 404 into an Indonesian service message',
    () async {
      final api = ComplaintApi(
        client: MockClient((request) async {
          expect(request.url.path.endsWith('/complaints/invalid'), isTrue);
          return http.Response(
            jsonEncode({'error': 'Kode pelacakan tidak ditemukan.'}),
            404,
          );
        }),
      );
      await expectLater(
        api.lookup('invalid'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Kode pelacakan tidak ditemukan.',
          ),
        ),
      );
      api.close();
    },
  );

  test('submit report never attaches the Neon connection secret', () async {
    final api = ComplaintApi(
      client: MockClient((request) async {
        expect(request.url.path.endsWith('/complaints'), isTrue);
        expect(request.body, contains('fullName'));
        expect(request.body, isNot(contains('DATABASE_URL')));
        return http.Response(
          jsonEncode({
            'id': '2b84c0a1-9ba4-4db5-8ef5-2bff3201319e',
            'status': 'received',
          }),
          201,
        );
      }),
    );
    final receipt = await api.submitReport(
      fullName: 'Rina Warga',
      neighbourhood: 'RT 02 / RW 04',
      category: 'Infrastruktur',
      title: 'Lampu jalan padam',
      description: 'Lampu jalan di dekat balai warga padam.',
    );
    expect(receipt.status, 'received');
    api.close();
  });
}
