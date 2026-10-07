import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/devotion_model.dart';
import 'dummy_data.dart';

final devotionRepositoryProvider = StateNotifierProvider<DevotionNotifier, List<DevotionModel>>((ref) {
  return DevotionNotifier();
});

final todayDevotionProvider = Provider<DevotionModel>((ref) {
  final devotions = ref.watch(devotionRepositoryProvider);
  final notifier = ref.read(devotionRepositoryProvider.notifier);
  return notifier.getTodayDevotionFrom(devotions);
});

class DevotionNotifier extends StateNotifier<List<DevotionModel>> {
  DevotionNotifier() : super(List.from(DummyData.devotions));

  DevotionModel get todayDevotion => getTodayDevotionFrom(state);

  DevotionModel getTodayDevotionFrom(List<DevotionModel> list) {
    if (list.isEmpty) return DummyData.devotions.first;

    // 1. Cek jika ada yang dipilih manual oleh Admin sebagai Word of the Day
    try {
      return list.firstWhere((d) => d.isWordOfTheDay);
    } catch (_) {}

    // 2. Cek apakah ada renungan yang tanggalnya persis hari ini
    final now = DateTime.now();
    try {
      return list.firstWhere((d) =>
        d.tanggal.year == now.year &&
        d.tanggal.month == now.month &&
        d.tanggal.day == now.day
      );
    } catch (_) {}

    // 3. Fallback ke renungan pertama
    return list.first;
  }

  DevotionModel? getById(String id) {
    try {
      return state.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  void toggleFavorite(String id) {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(isFavorite: !d.isFavorite) else d,
    ];
  }

  void setWordOfTheDay(String id) {
    state = [
      for (final d in state)
        d.copyWith(isWordOfTheDay: d.id == id),
    ];
  }

  void updateWordOfTheDayText({required String ayat, required String referensi}) {
    final current = todayDevotion;
    final updated = current.copyWith(
      ayat: ayat,
      referensi: referensi,
      isWordOfTheDay: true,
    );
    state = [
      for (final d in state)
        if (d.id == current.id) updated else d.copyWith(isWordOfTheDay: false),
    ];
  }

  void addDevotion(DevotionModel devotion) {
    state = [devotion, ...state];
  }

  void updateDevotion(DevotionModel devotion) {
    state = [
      for (final d in state)
        if (d.id == devotion.id) devotion else d,
    ];
  }

  void deleteDevotion(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}
