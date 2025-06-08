import '../models/mood.dart';
import '../services/mood_services.dart';

class MoodRepository {
  final MoodApiService _apiService;

  MoodRepository(this._apiService);

  Future<List<MoodEntry>> getMoodEntries() {
    return _apiService.fetchMoodEntries();
  }

  Future<void> addMoodEntry(MoodEntry entry) {
    return _apiService.addMoodEntry(entry);
  }

  Future<void> deleteMoodEntry(String id) {
    return _apiService.deleteMoodEntry(id);
  }
}
