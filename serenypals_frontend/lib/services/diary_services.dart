import '../models/diary.dart';
import 'dart:math';

// Simulasi layanan API untuk Virtual Diary
class DiaryApiService {
  final List<DiaryEntry> _diaryEntries = [];

  Future<List<DiaryEntry>> fetchDiaryEntries() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return List.from(_diaryEntries.reversed); // Urutkan dari terbaru
  }

  Future<DiaryEntry> addDiaryEntry(DiaryEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newEntry = entry.copyWith(id: Random().nextInt(100000).toString());
    _diaryEntries.add(newEntry);
    return newEntry;
  }

  Future<void> deleteDiaryEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _diaryEntries.removeWhere((entry) => entry.id == id);
  }

  // Anda bisa menambahkan updateDiaryEntry
}
