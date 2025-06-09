import '../models/mood.dart';
import '../services/mood_services.dart';

class MoodRepository {
  final MoodApiService _apiService;

  MoodRepository(this._apiService);
  Future<bool> shouldShowSurvey() async {
    try {
      final today = DateTime.now();
      if (today.day != 30) return false; // Hanya tanggal 30

      return !(await _apiService.hasEntryOnDate(today));
    } catch (e) {
      throw Exception('Failed to check survey status: $e');
    }
  }

  Future<List<MoodEntry>> getMoodEntries() {
    return _apiService.fetchMoodEntries();
  }

  Future<void> deleteMoodEntry(String id) {
    return _apiService.deleteMoodEntry(id);
  }

  Future<MoodEntry> submitSurvey(MoodEntry entry) async {
    try {
      final today = DateTime.now();
      if (today.day != 30) {
        throw Exception('Survey hanya tersedia di tanggal 30');
      }

      if (await _apiService.hasEntryOnDate(today)) {
        throw Exception('Anda sudah mengisi survei hari ini');
      }

      return await _apiService.addMoodEntry(entry);
    } catch (e) {
      throw Exception('Failed to submit survey: $e');
    }
  }
}
