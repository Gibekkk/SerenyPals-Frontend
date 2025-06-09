import 'package:equatable/equatable.dart';
import '../../models/mood.dart';

abstract class MoodJournalingState extends Equatable {
  const MoodJournalingState();
}

class SurveyInitial extends MoodJournalingState {
  const SurveyInitial();

  @override
  List<Object> get props => [];
}

class SurveyLoading extends MoodJournalingState {
  const SurveyLoading();

  @override
  List<Object> get props => [];
}

class SurveyAvailability extends MoodJournalingState {
  final bool shouldShow;

  const SurveyAvailability({required this.shouldShow});

  @override
  List<Object> get props => [shouldShow];
}

class SurveySubmissionSuccess extends MoodJournalingState {
  final MoodEntry entry;

  const SurveySubmissionSuccess({required this.entry});

  @override
  List<Object> get props => [entry];
}

class SurveyError extends MoodJournalingState {
  final String message;

  const SurveyError(this.message);

  @override
  List<Object> get props => [message];
}
