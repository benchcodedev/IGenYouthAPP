class PrayerRequestModel {
  final String id;
  final String userId;
  final String userName;
  final String isi;
  final bool anonim;
  final DateTime tanggal;
  final int prayCount;
  final bool hasPrayed;

  const PrayerRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.isi,
    this.anonim = false,
    required this.tanggal,
    this.prayCount = 0,
    this.hasPrayed = false,
  });

  String get displayName => anonim ? 'Sahabat IGen (Anonim)' : userName;

  PrayerRequestModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? isi,
    bool? anonim,
    DateTime? tanggal,
    int? prayCount,
    bool? hasPrayed,
  }) {
    return PrayerRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isi: isi ?? this.isi,
      anonim: anonim ?? this.anonim,
      tanggal: tanggal ?? this.tanggal,
      prayCount: prayCount ?? this.prayCount,
      hasPrayed: hasPrayed ?? this.hasPrayed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'isi': isi,
      'anonim': anonim,
      'tanggal': tanggal.toIso8601String(),
      'prayCount': prayCount,
    };
  }

  factory PrayerRequestModel.fromMap(Map<String, dynamic> map) {
    return PrayerRequestModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      isi: map['isi'] ?? '',
      anonim: map['anonim'] ?? false,
      tanggal: DateTime.tryParse(map['tanggal'] ?? '') ?? DateTime.now(),
      prayCount: (map['prayCount'] as num?)?.toInt() ?? 0,
      hasPrayed: map['hasPrayed'] ?? false,
    );
  }
}
