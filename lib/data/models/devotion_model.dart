class DevotionModel {
  final String id;
  final DateTime tanggal;
  final String judul;
  final String ayat;
  final String referensi;
  final String refleksi;
  final String doa;
  final String penulis;
  final bool isFavorite;
  final bool isWordOfTheDay;

  const DevotionModel({
    required this.id,
    required this.tanggal,
    required this.judul,
    required this.ayat,
    required this.referensi,
    required this.refleksi,
    this.doa = '',
    this.penulis = 'Pastor Youth',
    this.isFavorite = false,
    this.isWordOfTheDay = false,
  });

  DevotionModel copyWith({
    String? id,
    DateTime? tanggal,
    String? judul,
    String? ayat,
    String? referensi,
    String? refleksi,
    String? doa,
    String? penulis,
    bool? isFavorite,
    bool? isWordOfTheDay,
  }) {
    return DevotionModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      judul: judul ?? this.judul,
      ayat: ayat ?? this.ayat,
      referensi: referensi ?? this.referensi,
      refleksi: refleksi ?? this.refleksi,
      doa: doa ?? this.doa,
      penulis: penulis ?? this.penulis,
      isFavorite: isFavorite ?? this.isFavorite,
      isWordOfTheDay: isWordOfTheDay ?? this.isWordOfTheDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'judul': judul,
      'ayat': ayat,
      'referensi': referensi,
      'refleksi': refleksi,
      'doa': doa,
      'penulis': penulis,
      'isFavorite': isFavorite,
      'isWordOfTheDay': isWordOfTheDay,
    };
  }

  factory DevotionModel.fromMap(Map<String, dynamic> map) {
    return DevotionModel(
      id: map['id'] ?? '',
      tanggal: DateTime.tryParse(map['tanggal'] ?? '') ?? DateTime.now(),
      judul: map['judul'] ?? '',
      ayat: map['ayat'] ?? '',
      referensi: map['referensi'] ?? '',
      refleksi: map['refleksi'] ?? '',
      doa: map['doa'] ?? '',
      penulis: map['penulis'] ?? 'Pastor Youth',
      isFavorite: map['isFavorite'] ?? false,
      isWordOfTheDay: map['isWordOfTheDay'] ?? false,
    );
  }
}
