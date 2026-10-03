import 'package:flutter_test/flutter_test.dart';
import 'package:layanan_desa_cepoko/data/demo_auth_service.dart';

void main() {
  group('DemoAuthService', () {
    test('routes the two demo accounts to their distinct roles', () {
      final auth = DemoAuthService();

      expect(auth.signIn('warga@cepoko.test', 'CepokoWarga2026!')?.role,
          AccountRole.resident);
      expect(auth.signIn('petugas@cepoko.test', 'CepokoAdmin2026!')?.role,
          AccountRole.admin);
      expect(auth.signIn('warga@cepoko.test', 'wrong'), isNull);
    });

    test('registration is resident-only and exists for this session', () {
      final auth = DemoAuthService();

      expect(auth.register(name: 'Warga Baru', email: 'baru@example.id', password: 'password8'), isTrue);
      expect(auth.signIn('BARU@example.id', 'password8')?.role, AccountRole.resident);
      expect(auth.register(name: 'Duplikat', email: 'baru@example.id', password: 'password9'), isFalse);
    });

    test('password reset changes only a registered resident account', () {
      final auth = DemoAuthService();

      expect(auth.resetPassword(email: 'warga@cepoko.test', password: 'password8'), isTrue);
      expect(auth.signIn('warga@cepoko.test', 'password8')?.role, AccountRole.resident);
      expect(auth.resetPassword(email: 'petugas@cepoko.test', password: 'password8'), isFalse);
    });
    test('updates resident profile details', () {
      final auth = DemoAuthService();
      final updated = auth.updateProfile(
        email: 'warga@cepoko.test',
        name: 'Warga Cepoko Asli',
        phone: '081299998888',
        nik: '3374129999990001',
        rtRw: 'RT 05 / RW 02',
        address: 'Jl. Durian Raya',
      );
      expect(updated?.name, 'Warga Cepoko Asli');
      expect(updated?.phone, '081299998888');
      expect(updated?.rtRw, 'RT 05 / RW 02');
    });

    test('changes password with verification', () {
      final auth = DemoAuthService();
      expect(auth.changePassword(email: 'warga@cepoko.test', oldPassword: 'wrong', newPassword: 'newPass123!'), isFalse);
      expect(auth.changePassword(email: 'warga@cepoko.test', oldPassword: 'CepokoWarga2026!', newPassword: 'newPass123!'), isTrue);
      expect(auth.signIn('warga@cepoko.test', 'newPass123!'), isNotNull);
    });
  });
}
