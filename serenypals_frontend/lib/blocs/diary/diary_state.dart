import 'package:equatable/equatable.dart';
import '../../models/diary.dart';

abstract class VirtualDiaryState extends Equatable {
  const VirtualDiaryState();

  @override
  List<Object> get props => [];
}

class VirtualDiaryInitial extends VirtualDiaryState {
  const VirtualDiaryInitial();
}

class VirtualDiaryLoading extends VirtualDiaryState {
  const VirtualDiaryLoading();
}

class VirtualDiaryLoaded extends VirtualDiaryState {
  final List<DiaryEntry> entries;

  const VirtualDiaryLoaded({this.entries = const []});

  VirtualDiaryLoaded copyWith({
    List<DiaryEntry>? entries,
  }) {
    return VirtualDiaryLoaded(
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object> get props => [entries];
}

class VirtualDiaryError extends VirtualDiaryState {
  final String message;

  const VirtualDiaryError(this.message);

  @override
  List<Object> get props => [message];
}
