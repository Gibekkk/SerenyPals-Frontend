import 'package:equatable/equatable.dart';

class DiaryEntry extends Equatable {
  final String id;
  final String title;
  final String content;
  final String date; // Menggunakan String untuk format tampilan tanggal
  final String selectedEmoji;
  final DateTime timestamp; // Untuk sorting atau keperluan internal lainnya

  const DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.selectedEmoji,
    required this.timestamp,
  });

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      selectedEmoji: json['selectedEmoji'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'selectedEmoji': selectedEmoji,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    String? selectedEmoji,
    DateTime? timestamp,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      selectedEmoji: selectedEmoji ?? this.selectedEmoji,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, content, date, selectedEmoji, timestamp];
}
