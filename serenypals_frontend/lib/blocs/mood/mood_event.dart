import 'package:equatable/equatable.dart';
import '../../models/mood.dart';

abstract class MoodJournalingEvent extends Equatable {
  const MoodJournalingEvent();

  @override
  List<Object> get props => [];
}

class LoadMoodEntries extends MoodJournalingEvent {
  const LoadMoodEntries();
}

class AddMoodEntry extends MoodJournalingEvent {
  final MoodEntry entry;

  const AddMoodEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class DeleteMoodEntry extends MoodJournalingEvent {
  final String id;

  const DeleteMoodEntry(this.id);

  @override
  List<Object> get props => [id];
}

// Anda bisa menambahkan event lain, misalnya:
// class UpdateMoodEntry extends MoodJournalingEvent {
//   final MoodEntry entry;
//   const UpdateMoodEntry(this.entry);
//   @override
//   List<Object> get props => [entry];
// }
