import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/mood.dart';
import '../../repositories/mood_repository.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodJournalingBloc
    extends Bloc<MoodJournalingEvent, MoodJournalingState> {
  final MoodRepository _moodRepository;
  MoodJournalingBloc(this._moodRepository)
      : super(const MoodJournalingInitial()) {
    on<LoadMoodEntries>(_onLoadMoodEntries);
    on<AddMoodEntry>(_onAddMoodEntry);
    on<DeleteMoodEntry>(_onDeleteMoodEntry);
  }

  Future<void> _onLoadMoodEntries(
    LoadMoodEntries event,
    Emitter<MoodJournalingState> emit,
  ) async {
    try {
      emit(const MoodJournalingLoading());
      final entries = await _moodRepository.getMoodEntries();
      emit(MoodJournalingLoaded(entries: entries));
    } catch (e) {
      emit(MoodJournalingError('Failed to load mood entries: $e'));
    }
  }

  Future<void> _onAddMoodEntry(
    AddMoodEntry event,
    Emitter<MoodJournalingState> emit,
  ) async {
    try {
      // Dapatkan state saat ini untuk memperbarui daftar entries
      final currentState = state;
      List<MoodEntry> currentEntries = [];
      if (currentState is MoodJournalingLoaded) {
        currentEntries = List.from(currentState.entries);
      } else {
        // Jika belum loaded, load dulu
        emit(const MoodJournalingLoading());
        currentEntries = await _moodRepository.getMoodEntries();
      }

      final newEntry = await _moodRepository.addMoodEntry(event.entry);
      final updatedEntries = List<MoodEntry>.from(currentEntries);
      updatedEntries.insert(0, newEntry);
      emit(MoodJournalingLoaded(entries: updatedEntries));
    } catch (e) {
      emit(MoodJournalingError('Failed to add mood entry: $e'));
    }
  }

  Future<void> _onDeleteMoodEntry(
    DeleteMoodEntry event,
    Emitter<MoodJournalingState> emit,
  ) async {
    try {
      if (state is MoodJournalingLoaded) {
        final currentEntries = (state as MoodJournalingLoaded).entries;
        await _moodRepository.deleteMoodEntry(event.id);
        final updatedEntries =
            currentEntries.where((entry) => entry.id != event.id).toList();
        emit(MoodJournalingLoaded(entries: updatedEntries));
      }
    } catch (e) {
      emit(MoodJournalingError('Failed to delete mood entry: $e'));
    }
  }
}
