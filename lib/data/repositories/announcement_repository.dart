import 'package:flutter_riverpod/legacy.dart';
import '../models/announcement_model.dart';
import 'dummy_data.dart';

final announcementRepositoryProvider = StateNotifierProvider<AnnouncementNotifier, List<AnnouncementModel>>((ref) {
  return AnnouncementNotifier();
});

class AnnouncementNotifier extends StateNotifier<List<AnnouncementModel>> {
  AnnouncementNotifier() : super(List.from(DummyData.announcements));

  AnnouncementModel? getById(String id) {
    try {
      return state.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  void addAnnouncement(AnnouncementModel announcement) {
    state = [announcement, ...state];
  }

  void updateAnnouncement(AnnouncementModel announcement) {
    state = [
      for (final a in state)
        if (a.id == announcement.id) announcement else a,
    ];
  }

  void deleteAnnouncement(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void togglePin(String id) {
    state = [
      for (final a in state)
        if (a.id == id) a.copyWith(pinned: !a.pinned) else a,
    ];
  }
}
