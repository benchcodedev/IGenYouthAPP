import 'package:flutter_riverpod/legacy.dart';
import '../models/activity_model.dart';
import 'dummy_data.dart';

final activityRepositoryProvider = StateNotifierProvider<ActivityNotifier, List<ActivityModel>>((ref) {
  return ActivityNotifier();
});

class ActivityNotifier extends StateNotifier<List<ActivityModel>> {
  ActivityNotifier() : super(List.from(DummyData.activities));

  void addActivity(ActivityModel activity) {
    state = [...state, activity];
  }

  void updateActivity(ActivityModel activity) {
    state = [
      for (final a in state)
        if (a.id == activity.id) activity else a,
    ];
  }

  void deleteActivity(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}
