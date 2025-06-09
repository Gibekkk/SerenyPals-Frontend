import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/mood_repository.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodJournalingBloc
    extends Bloc<MoodJournalingEvent, MoodJournalingState> {
  final MoodRepository _moodRepository;

  MoodJournalingBloc(this._moodRepository) : super(const SurveyInitial()) {
    on<CheckSurveyAvailability>(_onCheckSurveyAvailability);
    on<SubmitSurvey>(_onSubmitSurvey);
  }

  Future<void> _onCheckSurveyAvailability(
    CheckSurveyAvailability event,
    Emitter<MoodJournalingState> emit,
  ) async {
    emit(const SurveyLoading());
    try {
      final shouldShow = await _moodRepository.shouldShowSurvey();
      emit(SurveyAvailability(shouldShow: shouldShow));
    } catch (e) {
      emit(SurveyError('Gagal memeriksa survei: $e'));
    }
  }

  Future<void> _onSubmitSurvey(
    SubmitSurvey event,
    Emitter<MoodJournalingState> emit,
  ) async {
    emit(const SurveyLoading());
    try {
      final entry = await _moodRepository.submitSurvey(event.entry);
      emit(SurveySubmissionSuccess(entry: entry));
    } catch (e) {
      emit(SurveyError('Gagal mengirim survei: $e'));
    }
  }
}
