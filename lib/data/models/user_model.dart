enum UserRole { guest, member, leader, admin }
enum UserCategory { youth, teens }

class UserModel {
  final String id;
  final String nama;
  final String email;
  final String wa;
  final DateTime tglLahir;
  final UserCategory kategori;
  final UserRole role;
  final String fotoUrl;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.wa,
    required this.tglLahir,
    this.kategori = UserCategory.youth,
    this.role = UserRole.member,
    this.fotoUrl = '',
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isLeader => role == UserRole.leader || role == UserRole.admin;
  bool get isGuest => role == UserRole.guest;

  UserModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? wa,
    DateTime? tglLahir,
    UserCategory? kategori,
    UserRole? role,
    String? fotoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      wa: wa ?? this.wa,
      tglLahir: tglLahir ?? this.tglLahir,
      kategori: kategori ?? this.kategori,
      role: role ?? this.role,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'wa': wa,
      'tglLahir': tglLahir.toIso8601String(),
      'kategori': kategori.name,
      'role': role.name,
      'fotoUrl': fotoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      wa: map['wa'] ?? '',
      tglLahir: DateTime.tryParse(map['tglLahir'] ?? '') ?? DateTime(2004, 1, 1),
      kategori: map['kategori'] == 'teens' ? UserCategory.teens : UserCategory.youth,
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.member,
      ),
      fotoUrl: map['fotoUrl'] ?? '',
    );
  }
}
