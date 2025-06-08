import 'package:equatable/equatable.dart';

class MoodEntry extends Equatable {
  final String id;
  final double moodLevel;
  final String? issue; // Masalah yang diceritakan, bisa null
  final String? story; // Cerita detail, bisa null
  final DateTime timestamp;

  const MoodEntry({
    required this.id,
    required this.moodLevel,
    this.issue,
    this.story,
    required this.timestamp,
  });

  // Factory constructor untuk membuat MoodEntry dari JSON (misal dari API)
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      moodLevel: (json['moodLevel'] as num).toDouble(),
      issue: json['issue'],
      story: json['story'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Method untuk mengubah MoodEntry menjadi JSON (misal untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moodLevel': moodLevel,
      'issue': issue,
      'story': story,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Untuk memungkinkan perubahan sebagian data (opsional, tergantung kebutuhan)
  MoodEntry copyWith({
    String? id,
    double? moodLevel,
    String? issue,
    String? story,
    DateTime? timestamp,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      moodLevel: moodLevel ?? this.moodLevel,
      issue: issue ?? this.issue,
      story: story ?? this.story,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, moodLevel, issue, story, timestamp];
}
