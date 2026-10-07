import 'package:flutter_riverpod/legacy.dart';
import '../models/event_model.dart';
import '../models/event_registration_model.dart';
import 'dummy_data.dart';

final eventRepositoryProvider = StateNotifierProvider<EventNotifier, List<EventModel>>((ref) {
  return EventNotifier();
});

final registrationsProvider = StateNotifierProvider<RegistrationNotifier, List<EventRegistrationModel>>((ref) {
  return RegistrationNotifier();
});

class EventNotifier extends StateNotifier<List<EventModel>> {
  EventNotifier() : super(List.from(DummyData.events));

  EventModel? getById(String id) {
    try {
      return state.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void addEvent(EventModel event) {
    state = [event, ...state];
  }

  void updateEvent(EventModel event) {
    state = [
      for (final e in state)
        if (e.id == event.id) event else e,
    ];
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void decrementQuota(String id) {
    state = [
      for (final e in state)
        if (e.id == id && e.sisaKuota > 0)
          e.copyWith(sisaKuota: e.sisaKuota - 1)
        else
          e,
    ];
  }
}

class RegistrationNotifier extends StateNotifier<List<EventRegistrationModel>> {
  RegistrationNotifier() : super(List.from(DummyData.userRegistrations));

  bool isUserRegistered(String eventId, String userId) {
    return state.any((r) => r.eventId == eventId && r.userId == userId);
  }

  EventRegistrationModel? getRegistration(String eventId, String userId) {
    try {
      return state.firstWhere((r) => r.eventId == eventId && r.userId == userId);
    } catch (_) {
      return null;
    }
  }

  EventRegistrationModel register({
    required String eventId,
    required String userId,
    required String userName,
    required String userWa,
  }) {
    final regId = 'reg_${DateTime.now().millisecondsSinceEpoch}';
    final qr = 'IGEN-${eventId.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final newReg = EventRegistrationModel(
      id: regId,
      eventId: eventId,
      userId: userId,
      userName: userName,
      userWa: userWa,
      status: 'Terdaftar',
      qrCode: qr,
      registeredAt: DateTime.now(),
    );
    state = [newReg, ...state];
    return newReg;
  }

  bool checkInWithQr(String qrCode) {
    bool found = false;
    state = [
      for (final r in state)
        if (r.qrCode == qrCode || r.id == qrCode) ...[
          r.copyWith(status: 'Checked-In', checkedInAt: DateTime.now()),
          ...() { found = true; return []; }(),
        ] else
          r,
    ];
    return found;
  }
}
