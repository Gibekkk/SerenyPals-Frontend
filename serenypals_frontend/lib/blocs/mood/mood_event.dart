import 'package:equatable/equatable.dart';
import '../../models/mood.dart';

abstract class MoodJournalingEvent extends Equatable {
  const MoodJournalingEvent();
}

class CheckSurveyAvailability extends MoodJournalingEvent {
  const CheckSurveyAvailability();

  @override
  List<Object> get props => [];
}

class SubmitSurvey extends MoodJournalingEvent {
  final MoodEntry entry;

  const SubmitSurvey(this.entry);

  @override
  List<Object> get props => [entry];
}
