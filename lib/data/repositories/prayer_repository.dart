import 'package:flutter_riverpod/legacy.dart';
import '../models/prayer_request_model.dart';
import 'dummy_data.dart';

final prayerRepositoryProvider = StateNotifierProvider<PrayerNotifier, List<PrayerRequestModel>>((ref) {
  return PrayerNotifier();
});

class PrayerNotifier extends StateNotifier<List<PrayerRequestModel>> {
  PrayerNotifier() : super(List.from(DummyData.prayerRequests));

  void submitPrayer({
    required String userId,
    required String userName,
    required String isi,
    required bool anonim,
  }) {
    final newPrayer = PrayerRequestModel(
      id: 'pray_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      isi: isi,
      anonim: anonim,
      tanggal: DateTime.now(),
      prayCount: 1,
      hasPrayed: true,
    );
    state = [newPrayer, ...state];
  }

  void togglePray(String id) {
    state = [
      for (final p in state)
        if (p.id == id)
          p.copyWith(
            hasPrayed: !p.hasPrayed,
            prayCount: p.hasPrayed ? (p.prayCount - 1) : (p.prayCount + 1),
          )
        else
          p,
    ];
  }
}
