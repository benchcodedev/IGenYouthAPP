import 'package:flutter_riverpod/legacy.dart';
import '../models/komsel_model.dart';
import '../models/komsel_member_model.dart';
import 'dummy_data.dart';

final komselRepositoryProvider = StateNotifierProvider<KomselNotifier, List<KomselModel>>((ref) {
  return KomselNotifier();
});

final komselRequestsProvider = StateNotifierProvider<KomselRequestNotifier, List<KomselMemberModel>>((ref) {
  return KomselRequestNotifier();
});

class KomselNotifier extends StateNotifier<List<KomselModel>> {
  KomselNotifier() : super(List.from(DummyData.komselList));

  KomselModel? getById(String id) {
    try {
      return state.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }

  void addKomsel(KomselModel komsel) {
    state = [komsel, ...state];
  }

  void updateKomsel(KomselModel komsel) {
    state = [
      for (final k in state)
        if (k.id == komsel.id) komsel else k,
    ];
  }

  void deleteKomsel(String id) {
    state = state.where((k) => k.id != id).toList();
  }

  void incrementMember(String id) {
    state = [
      for (final k in state)
        if (k.id == id) k.copyWith(anggotaCount: k.anggotaCount + 1) else k,
    ];
  }
}

class KomselRequestNotifier extends StateNotifier<List<KomselMemberModel>> {
  KomselRequestNotifier() : super(List.from(DummyData.komselRequests));

  String? getUserStatus(String komselId, String userId) {
    try {
      final req = state.firstWhere(
        (r) => r.komselId == komselId && r.userId == userId,
      );
      return req.status;
    } catch (_) {
      return null;
    }
  }

  void requestJoin({
    required String komselId,
    required String komselNama,
    required String userId,
    required String userName,
    required String userWa,
  }) {
    final existingIndex = state.indexWhere((r) => r.komselId == komselId && r.userId == userId);
    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(status: 'pending', requestedAt: DateTime.now())
          else
            state[i],
      ];
    } else {
      final newReq = KomselMemberModel(
        id: 'km_req_${DateTime.now().millisecondsSinceEpoch}',
        komselId: komselId,
        komselNama: komselNama,
        userId: userId,
        userName: userName,
        userWa: userWa,
        status: 'pending',
        requestedAt: DateTime.now(),
      );
      state = [newReq, ...state];
    }
  }

  void approveRequest(String requestId) {
    state = [
      for (final r in state)
        if (r.id == requestId) r.copyWith(status: 'approved') else r,
    ];
  }

  void rejectRequest(String requestId) {
    state = [
      for (final r in state)
        if (r.id == requestId) r.copyWith(status: 'rejected') else r,
    ];
  }
}
