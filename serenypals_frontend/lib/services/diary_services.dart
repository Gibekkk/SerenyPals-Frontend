import '../models/diary.dart';
import 'dart:math';

class DiaryApiService {
  final List<DiaryEntry> _diaryEntries = [
    DiaryEntry(
      id: '1',
      title: 'Hari yang menyenangkan',
      content: 'Hari ini aku merasa sangat bahagia karena...',
      date: '10 Juni 2024',
      selectedEmoji: '😊',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DiaryEntry(
        id: '2',
        title: 'Sedih hari ini',
        content: 'Aku kecewa dengan hasil ujianku...',
        date: '9 Juni 2024',
        selectedEmoji: '😢',
        timestamp: DateTime.now().subtract(const Duration(days: 3))),
  ];

  Future<List<DiaryEntry>> fetchDiaryEntries() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return List.from(_diaryEntries)
      ..sort(
          (a, b) => b.timestamp.compareTo(a.timestamp)); // Urutkan dari terbaru
  }

  Future<DiaryEntry> addDiaryEntry(DiaryEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newEntry = entry.copyWith(
      id: Random().nextInt(100000).toString(),
      timestamp: DateTime.now(),
    );
    _diaryEntries.add(newEntry);
    return newEntry;
  }

  Future<DiaryEntry> updateDiaryEntry(DiaryEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _diaryEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      final updatedEntry = entry.copyWith(timestamp: DateTime.now());
      _diaryEntries[index] = updatedEntry;
      return updatedEntry;
    }
    throw Exception('Entry not found');
  }

  Future<void> deleteDiaryEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _diaryEntries.removeWhere((entry) => entry.id == id);
  }
}
