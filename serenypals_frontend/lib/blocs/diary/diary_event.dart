import 'package:equatable/equatable.dart';
import '../../models/diary.dart';

abstract class VirtualDiaryEvent extends Equatable {
  const VirtualDiaryEvent();

  @override
  List<Object> get props => [];
}

class LoadDiaryEntries extends VirtualDiaryEvent {
  const LoadDiaryEntries();
}

class AddDiaryEntry extends VirtualDiaryEvent {
  final DiaryEntry entry;

  const AddDiaryEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class DeleteDiaryEntry extends VirtualDiaryEvent {
  final String id;

  const DeleteDiaryEntry(this.id);

  @override
  List<Object> get props => [id];
}

// Anda bisa menambahkan event lain, misalnya:
class UpdateDiaryEntry extends VirtualDiaryEvent {
  final DiaryEntry entry;
  const UpdateDiaryEntry(this.entry);
  @override
  List<Object> get props => [entry];
}
