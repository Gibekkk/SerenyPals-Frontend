import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/diary.dart';
import '../../repositories/diary_repository.dart';
import 'diary_event.dart';
import 'diary_state.dart';

class VirtualDiaryBloc extends Bloc<VirtualDiaryEvent, VirtualDiaryState> {
  final DiaryRepository _diaryRepository;

  VirtualDiaryBloc(this._diaryRepository) : super(const VirtualDiaryInitial()) {
    on<LoadDiaryEntries>(_onLoadDiaryEntries);
    on<AddDiaryEntry>(_onAddDiaryEntry);
    on<DeleteDiaryEntry>(_onDeleteDiaryEntry);
  }

  Future<void> _onLoadDiaryEntries(
    LoadDiaryEntries event,
    Emitter<VirtualDiaryState> emit,
  ) async {
    try {
      emit(const VirtualDiaryLoading());
      final entries = await _diaryRepository.getDiaryEntries();
      emit(VirtualDiaryLoaded(entries: entries));
    } catch (e) {
      emit(VirtualDiaryError('Failed to load diary entries: $e'));
    }
  }

  Future<void> _onAddDiaryEntry(
    AddDiaryEntry event,
    Emitter<VirtualDiaryState> emit,
  ) async {
    try {
      // Dapatkan state saat ini untuk memperbarui daftar entries
      final currentState = state;
      List<DiaryEntry> currentEntries = [];
      if (currentState is VirtualDiaryLoaded) {
        currentEntries = List.from(currentState.entries);
      } else {
        // Jika belum loaded, load dulu (opsional, tergantung alur aplikasi)
        emit(const VirtualDiaryLoading());
        currentEntries = await _diaryRepository.getDiaryEntries();
      }

      final newEntry = await _diaryRepository.addDiaryEntry(event.entry);
      final updatedEntries = List<DiaryEntry>.from(currentEntries)
        ..insert(0, newEntry);
      emit(VirtualDiaryLoaded(entries: updatedEntries));
    } catch (e) {
      emit(VirtualDiaryError('Failed to add diary entry: $e'));
    }
  }

  Future<void> _onDeleteDiaryEntry(
    DeleteDiaryEntry event,
    Emitter<VirtualDiaryState> emit,
  ) async {
    try {
      if (state is VirtualDiaryLoaded) {
        final currentEntries = (state as VirtualDiaryLoaded).entries;
        await _diaryRepository.deleteDiaryEntry(event.id);
        final updatedEntries =
            currentEntries.where((entry) => entry.id != event.id).toList();
        emit(VirtualDiaryLoaded(entries: updatedEntries));
      }
    } catch (e) {
      emit(VirtualDiaryError('Failed to delete diary entry: $e'));
    }
  }
}
