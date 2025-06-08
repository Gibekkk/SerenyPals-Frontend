import '../models/diary.dart';
import '../services/diary_services.dart';

class DiaryRepository {
  final DiaryApiService _apiService;

  DiaryRepository(this._apiService);

  Future<List<DiaryEntry>> getDiaryEntries() {
    return _apiService.fetchDiaryEntries();
  }

  Future<void> addDiaryEntry(DiaryEntry entry) {
    return _apiService.addDiaryEntry(entry);
  }

  Future<void> deleteDiaryEntry(String id) {
    return _apiService.deleteDiaryEntry(id);
  }
}
