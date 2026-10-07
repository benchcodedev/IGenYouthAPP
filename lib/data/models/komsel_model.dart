class KomselModel {
  final String id;
  final String nama;
  final String deskripsi;
  final String leaderId;
  final String leaderName;
  final String leaderWa;
  final String leaderFoto;
  final String hari; // 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  final String jam; // '19:00 WIB'
  final String wilayah; // 'Jakarta Barat', 'Jakarta Selatan', dll.
  final String alamat;
  final double lat;
  final double lng;
  final String kategori; // 'Youth', 'Teens', 'Pelajar', 'Mahasiswa', 'Pekerja'
  final int kuota;
  final int anggotaCount;

  const KomselModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.leaderId,
    required this.leaderName,
    required this.leaderWa,
    this.leaderFoto = '',
    required this.hari,
    required this.jam,
    required this.wilayah,
    required this.alamat,
    this.lat = -6.2088,
    this.lng = 106.8456,
    required this.kategori,
    this.kuota = 15,
    this.anggotaCount = 8,
  });

  bool get isPenuh => anggotaCount >= kuota;

  KomselModel copyWith({
    String? id,
    String? nama,
    String? deskripsi,
    String? leaderId,
    String? leaderName,
    String? leaderWa,
    String? leaderFoto,
    String? hari,
    String? jam,
    String? wilayah,
    String? alamat,
    double? lat,
    double? lng,
    String? kategori,
    int? kuota,
    int? anggotaCount,
  }) {
    return KomselModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      leaderId: leaderId ?? this.leaderId,
      leaderName: leaderName ?? this.leaderName,
      leaderWa: leaderWa ?? this.leaderWa,
      leaderFoto: leaderFoto ?? this.leaderFoto,
      hari: hari ?? this.hari,
      jam: jam ?? this.jam,
      wilayah: wilayah ?? this.wilayah,
      alamat: alamat ?? this.alamat,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      kategori: kategori ?? this.kategori,
      kuota: kuota ?? this.kuota,
      anggotaCount: anggotaCount ?? this.anggotaCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'leaderId': leaderId,
      'leaderName': leaderName,
      'leaderWa': leaderWa,
      'leaderFoto': leaderFoto,
      'hari': hari,
      'jam': jam,
      'wilayah': wilayah,
      'alamat': alamat,
      'lat': lat,
      'lng': lng,
      'kategori': kategori,
      'kuota': kuota,
      'anggotaCount': anggotaCount,
    };
  }

  factory KomselModel.fromMap(Map<String, dynamic> map) {
    return KomselModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      leaderId: map['leaderId'] ?? '',
      leaderName: map['leaderName'] ?? '',
      leaderWa: map['leaderWa'] ?? '',
      leaderFoto: map['leaderFoto'] ?? '',
      hari: map['hari'] ?? 'Jumat',
      jam: map['jam'] ?? '19:00 WIB',
      wilayah: map['wilayah'] ?? 'Jakarta Barat',
      alamat: map['alamat'] ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? -6.2088,
      lng: (map['lng'] as num?)?.toDouble() ?? 106.8456,
      kategori: map['kategori'] ?? 'Youth',
      kuota: (map['kuota'] as num?)?.toInt() ?? 15,
      anggotaCount: (map['anggotaCount'] as num?)?.toInt() ?? 8,
    );
  }
}
