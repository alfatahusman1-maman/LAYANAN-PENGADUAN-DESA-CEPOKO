enum AccountRole { resident, admin }

class DemoAccount {
  const DemoAccount({
    required this.name,
    required this.email,
    required this.role,
    this.phone = '0812-3456-7890',
    this.nik = '3374121205980001',
    this.rtRw = 'RT 03 / RW 01',
    this.address = 'Jl. Cepoko Raya, Kelurahan Cepoko, Kec. Gunungpati, Semarang',
  });

  final String name;
  final String email;
  final AccountRole role;
  final String phone;
  final String nik;
  final String rtRw;
  final String address;

  DemoAccount copyWith({
    String? name,
    String? email,
    AccountRole? role,
    String? phone,
    String? nik,
    String? rtRw,
    String? address,
  }) => DemoAccount(
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    phone: phone ?? this.phone,
    nik: nik ?? this.nik,
    rtRw: rtRw ?? this.rtRw,
    address: address ?? this.address,
  );
}

/// Prototype-only in-memory sign-in with full profile management support.
class DemoAuthService {
  final Map<String, _AccountRecord> _accounts = {
    'warga@cepoko.test': _AccountRecord(
      name: 'Warga Cepoko',
      password: 'CepokoWarga2026!',
      role: AccountRole.resident,
      phone: '0812-3456-7890',
      nik: '3374121205980001',
      rtRw: 'RT 03 / RW 01',
      address: 'Jl. Cepoko Raya No. 12, Kel. Cepoko, Kec. Gunungpati',
    ),
    'petugas@cepoko.test': _AccountRecord(
      name: 'Petugas Kelurahan Cepoko',
      password: 'CepokoAdmin2026!',
      role: AccountRole.admin,
      phone: '0857-9876-5432',
      nik: '3374120101850002',
      rtRw: 'RT 04 / RW 01',
      address: 'Kantor Kelurahan Cepoko, Jl. Cepoko Raya, Kec. Gunungpati',
    ),
  };

  DemoAccount? signIn(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final record = _accounts[normalizedEmail];
    if (record == null || record.password != password) return null;
    return DemoAccount(
      name: record.name,
      email: normalizedEmail,
      role: record.role,
      phone: record.phone,
      nik: record.nik,
      rtRw: record.rtRw,
      address: record.address,
    );
  }

  bool register({required String name, required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) return false;
    _accounts[normalizedEmail] = _AccountRecord(
      name: name.trim(),
      password: password,
      role: AccountRole.resident,
      phone: '',
      nik: '',
      rtRw: 'RT 01 / RW 01',
      address: 'Kelurahan Cepoko, Kec. Gunungpati',
    );
    return true;
  }

  DemoAccount? updateProfile({
    required String email,
    required String name,
    String? phone,
    String? nik,
    String? rtRw,
    String? address,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null) return null;

    final updated = _AccountRecord(
      name: name.trim(),
      password: account.password,
      role: account.role,
      phone: (phone ?? account.phone).trim(),
      nik: (nik ?? account.nik).trim(),
      rtRw: (rtRw ?? account.rtRw).trim(),
      address: (address ?? account.address).trim(),
    );
    _accounts[normalizedEmail] = updated;

    return DemoAccount(
      name: updated.name,
      email: normalizedEmail,
      role: updated.role,
      phone: updated.phone,
      nik: updated.nik,
      rtRw: updated.rtRw,
      address: updated.address,
    );
  }

  bool changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null || account.password != oldPassword) return false;

    _accounts[normalizedEmail] = _AccountRecord(
      name: account.name,
      password: newPassword,
      role: account.role,
      phone: account.phone,
      nik: account.nik,
      rtRw: account.rtRw,
      address: account.address,
    );
    return true;
  }

  bool resetPassword({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];
    if (account == null || account.role == AccountRole.admin) return false;
    _accounts[normalizedEmail] = _AccountRecord(
      name: account.name,
      password: password,
      role: account.role,
      phone: account.phone,
      nik: account.nik,
      rtRw: account.rtRw,
      address: account.address,
    );
    return true;
  }
}

class _AccountRecord {
  _AccountRecord({
    required this.name,
    required this.password,
    required this.role,
    this.phone = '',
    this.nik = '',
    this.rtRw = '',
    this.address = '',
  });

  final String name;
  final String password;
  final AccountRole role;
  final String phone;
  final String nik;
  final String rtRw;
  final String address;
}
