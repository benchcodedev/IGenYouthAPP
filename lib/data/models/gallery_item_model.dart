class GalleryItemModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String imageUrl;
  final String kategori;
  final DateTime tanggal;

  const GalleryItemModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.imageUrl,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'imageUrl': imageUrl,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  factory GalleryItemModel.fromMap(Map<String, dynamic> map) {
    return GalleryItemModel(
      id: map['id'] ?? '',
      judul: map['judul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      kategori: map['kategori'] ?? 'Momen Bersama',
      tanggal: DateTime.tryParse(map['tanggal'] ?? '') ?? DateTime.now(),
    );
  }
}
