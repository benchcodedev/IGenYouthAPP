enum EventCategory { semua, youthNight, camp, outing, worshipNight, baksos }

class EventModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String posterUrl;
  final DateTime mulai;
  final DateTime selesai;
  final String lokasi;
  final String alamat;
  final double lat;
  final double lng;
  final int harga; // 0 for gratis
  final int kuota;
  final int sisaKuota;
  final EventCategory kategori;
  final String status; // 'Buka', 'Penuh', 'Selesai'
  final String picName;
  final String picWa;

  const EventModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.posterUrl,
    required this.mulai,
    required this.selesai,
    required this.lokasi,
    required this.alamat,
    this.lat = -6.2088,
    this.lng = 106.8456,
    this.harga = 0,
    required this.kuota,
    required this.sisaKuota,
    required this.kategori,
    this.status = 'Buka',
    this.picName = 'Kak Daniel',
    this.picWa = '6281234567890',
  });

  bool get isGratis => harga == 0;

  String get kategoriLabel {
    switch (kategori) {
      case EventCategory.camp:
        return 'Youth Camp';
      case EventCategory.outing:
        return 'Outing & Fellowship';
      case EventCategory.worshipNight:
        return 'Worship Night';
      case EventCategory.baksos:
        return 'Bakti Sosial';
      case EventCategory.youthNight:
      default:
        return 'Youth Night';
    }
  }

  EventModel copyWith({
    String? id,
    String? judul,
    String? deskripsi,
    String? posterUrl,
    DateTime? mulai,
    DateTime? selesai,
    String? lokasi,
    String? alamat,
    double? lat,
    double? lng,
    int? harga,
    int? kuota,
    int? sisaKuota,
    EventCategory? kategori,
    String? status,
    String? picName,
    String? picWa,
  }) {
    return EventModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      posterUrl: posterUrl ?? this.posterUrl,
      mulai: mulai ?? this.mulai,
      selesai: selesai ?? this.selesai,
      lokasi: lokasi ?? this.lokasi,
      alamat: alamat ?? this.alamat,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      harga: harga ?? this.harga,
      kuota: kuota ?? this.kuota,
      sisaKuota: sisaKuota ?? this.sisaKuota,
      kategori: kategori ?? this.kategori,
      status: status ?? this.status,
      picName: picName ?? this.picName,
      picWa: picWa ?? this.picWa,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'posterUrl': posterUrl,
      'mulai': mulai.toIso8601String(),
      'selesai': selesai.toIso8601String(),
      'lokasi': lokasi,
      'alamat': alamat,
      'lat': lat,
      'lng': lng,
      'harga': harga,
      'kuota': kuota,
      'sisaKuota': sisaKuota,
      'kategori': kategori.name,
      'status': status,
      'picName': picName,
      'picWa': picWa,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      posterUrl: map['posterUrl'] ?? '',
      mulai: DateTime.tryParse(map['mulai'] ?? '') ?? DateTime.now(),
      selesai: DateTime.tryParse(map['selesai'] ?? '') ?? DateTime.now(),
      lokasi: map['lokasi'] ?? '',
      alamat: map['alamat'] ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? -6.2088,
      lng: (map['lng'] as num?)?.toDouble() ?? 106.8456,
      harga: (map['harga'] as num?)?.toInt() ?? 0,
      kuota: (map['kuota'] as num?)?.toInt() ?? 100,
      sisaKuota: (map['sisaKuota'] as num?)?.toInt() ?? 100,
      kategori: EventCategory.values.firstWhere(
        (k) => k.name == map['kategori'],
        orElse: () => EventCategory.youthNight,
      ),
      status: map['status'] ?? 'Buka',
      picName: map['picName'] ?? 'PIC Event',
      picWa: map['picWa'] ?? '6281234567890',
    );
  }
}
