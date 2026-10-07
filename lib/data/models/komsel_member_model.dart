class KomselMemberModel {
  final String id;
  final String komselId;
  final String komselNama;
  final String userId;
  final String userName;
  final String userWa;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime requestedAt;

  const KomselMemberModel({
    required this.id,
    required this.komselId,
    required this.komselNama,
    required this.userId,
    required this.userName,
    required this.userWa,
    this.status = 'pending',
    required this.requestedAt,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';

  KomselMemberModel copyWith({
    String? id,
    String? komselId,
    String? komselNama,
    String? userId,
    String? userName,
    String? userWa,
    String? status,
    DateTime? requestedAt,
  }) {
    return KomselMemberModel(
      id: id ?? this.id,
      komselId: komselId ?? this.komselId,
      komselNama: komselNama ?? this.komselNama,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userWa: userWa ?? this.userWa,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'komselId': komselId,
      'komselNama': komselNama,
      'userId': userId,
      'userName': userName,
      'userWa': userWa,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  factory KomselMemberModel.fromMap(Map<String, dynamic> map) {
    return KomselMemberModel(
      id: map['id'] ?? '',
      komselId: map['komselId'] ?? '',
      komselNama: map['komselNama'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userWa: map['userWa'] ?? '',
      status: map['status'] ?? 'pending',
      requestedAt: DateTime.tryParse(map['requestedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
