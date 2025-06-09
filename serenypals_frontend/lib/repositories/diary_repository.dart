import '../models/diary.dart';
import '../services/diary_services.dart';

class DiaryRepository {
  final DiaryApiService _apiService;

  DiaryRepository(this._apiService);

  Future<List<DiaryEntry>> getDiaryEntries() async {
    return await _apiService.fetchDiaryEntries();
  }

  Future<DiaryEntry> addDiaryEntry(DiaryEntry entry) async {
    return await _apiService.addDiaryEntry(entry);
  }

  Future<DiaryEntry> updateDiaryEntry(DiaryEntry entry) async {
    return await _apiService.updateDiaryEntry(entry);
  }

  Future<void> deleteDiaryEntry(String id) async {
    await _apiService.deleteDiaryEntry(id);
  }
}
