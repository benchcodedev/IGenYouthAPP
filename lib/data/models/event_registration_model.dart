class EventRegistrationModel {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String userWa;
  final String status; // 'Terdaftar', 'Checked-In', 'Dibatalkan'
  final String qrCode;
  final DateTime registeredAt;
  final DateTime? checkedInAt;

  const EventRegistrationModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.userWa,
    this.status = 'Terdaftar',
    required this.qrCode,
    required this.registeredAt,
    this.checkedInAt,
  });

  bool get isCheckedIn => status == 'Checked-In';

  EventRegistrationModel copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? userName,
    String? userWa,
    String? status,
    String? qrCode,
    DateTime? registeredAt,
    DateTime? checkedInAt,
  }) {
    return EventRegistrationModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userWa: userWa ?? this.userWa,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
      registeredAt: registeredAt ?? this.registeredAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'userWa': userWa,
      'status': status,
      'qrCode': qrCode,
      'registeredAt': registeredAt.toIso8601String(),
      'checkedInAt': checkedInAt?.toIso8601String(),
    };
  }

  factory EventRegistrationModel.fromMap(Map<String, dynamic> map) {
    return EventRegistrationModel(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userWa: map['userWa'] ?? '',
      status: map['status'] ?? 'Terdaftar',
      qrCode: map['qrCode'] ?? '',
      registeredAt: DateTime.tryParse(map['registeredAt'] ?? '') ?? DateTime.now(),
      checkedInAt: map['checkedInAt'] != null ? DateTime.tryParse(map['checkedInAt']) : null,
    );
  }
}
