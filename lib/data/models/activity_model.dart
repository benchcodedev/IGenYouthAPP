class ActivityModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String hari; // 'Sabtu', 'Minggu', 'Rabu', dll.
  final String jam; // '17:00 WIB'
  final String lokasi;
  final bool rutin;
  final String pic;
  final String badge;

  const ActivityModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.hari,
    required this.jam,
    required this.lokasi,
    this.rutin = true,
    this.pic = 'Tim Youth',
    this.badge = 'Rutin',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'hari': hari,
      'jam': jam,
      'lokasi': lokasi,
      'rutin': rutin,
      'pic': pic,
      'badge': badge,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      hari: map['hari'] ?? 'Sabtu',
      jam: map['jam'] ?? '17:00 WIB',
      lokasi: map['lokasi'] ?? '',
      rutin: map['rutin'] ?? true,
      pic: map['pic'] ?? 'Tim Youth',
      badge: map['badge'] ?? 'Rutin',
    );
  }
}
