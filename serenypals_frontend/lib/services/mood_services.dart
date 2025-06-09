import '../../models/mood.dart';
import 'dart:math';

// Simulasi layanan API untuk Mood Journaling
class MoodApiService {
  // Data dummy sebagai pengganti database/API
  final List<MoodEntry> _moodEntries = [];
  Future<bool> hasEntryOnDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _moodEntries.any((entry) =>
        entry.timestamp.year == date.year &&
        entry.timestamp.month == date.month &&
        entry.timestamp.day == date.day);
  }

  Future<MoodEntry> addMoodEntry(MoodEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newEntry = entry.copyWith(id: Random().nextInt(100000).toString());
    _moodEntries.add(newEntry);
    return newEntry;
  }

  Future<List<MoodEntry>> fetchMoodEntries() async {
    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(milliseconds: 700));
    // Mengembalikan salinan data untuk mencegah modifikasi eksternal langsung
    return List.from(_moodEntries.reversed); // Urutkan dari terbaru
  }

  Future<void> deleteMoodEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _moodEntries.removeWhere((entry) => entry.id == id);
  }

  // Anda bisa menambahkan method lain seperti updateMoodEntry
}
