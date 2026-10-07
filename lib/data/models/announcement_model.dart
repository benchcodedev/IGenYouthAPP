class AnnouncementModel {
  final String id;
  final String judul;
  final String isi;
  final String label; // 'Penting', 'Umum', 'Pelayanan'
  final bool pinned;
  final String gambarUrl;
  final DateTime tanggal;
  final String? actionUrl;
  final String author;

  const AnnouncementModel({
    required this.id,
    required this.judul,
    required this.isi,
    this.label = 'Umum',
    this.pinned = false,
    this.gambarUrl = '',
    required this.tanggal,
    this.actionUrl,
    this.author = 'Tim Media IGen',
  });

  AnnouncementModel copyWith({
    String? id,
    String? judul,
    String? isi,
    String? label,
    bool? pinned,
    String? gambarUrl,
    DateTime? tanggal,
    String? actionUrl,
    String? author,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      label: label ?? this.label,
      pinned: pinned ?? this.pinned,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      tanggal: tanggal ?? this.tanggal,
      actionUrl: actionUrl ?? this.actionUrl,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'label': label,
      'pinned': pinned,
      'gambarUrl': gambarUrl,
      'tanggal': tanggal.toIso8601String(),
      'actionUrl': actionUrl,
      'author': author,
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] ?? '',
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      label: map['label'] ?? 'Umum',
      pinned: map['pinned'] ?? false,
      gambarUrl: map['gambarUrl'] ?? '',
      tanggal: DateTime.tryParse(map['tanggal'] ?? '') ?? DateTime.now(),
      actionUrl: map['actionUrl'],
      author: map['author'] ?? 'Tim Media IGen',
    );
  }
}
