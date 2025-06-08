import 'package:equatable/equatable.dart';
import '../../models/mood.dart';

abstract class MoodJournalingState extends Equatable {
  const MoodJournalingState();

  @override
  List<Object> get props => [];
}

class MoodJournalingInitial extends MoodJournalingState {
  const MoodJournalingInitial();
}

class MoodJournalingLoading extends MoodJournalingState {
  const MoodJournalingLoading();
}

class MoodJournalingLoaded extends MoodJournalingState {
  final List<MoodEntry> entries;

  const MoodJournalingLoaded({this.entries = const []});

  MoodJournalingLoaded copyWith({
    List<MoodEntry>? entries,
  }) {
    return MoodJournalingLoaded(
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object> get props => [entries];
}

class MoodJournalingError extends MoodJournalingState {
  final String message;

  const MoodJournalingError(this.message);

  @override
  List<Object> get props => [message];
}
