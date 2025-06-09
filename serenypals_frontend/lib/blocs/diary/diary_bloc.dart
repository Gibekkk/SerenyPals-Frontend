import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/diary_repository.dart';
import 'diary_event.dart';
import 'diary_state.dart';

class VirtualDiaryBloc extends Bloc<VirtualDiaryEvent, VirtualDiaryState> {
  final DiaryRepository _diaryRepository;

  VirtualDiaryBloc(this._diaryRepository) : super(const VirtualDiaryInitial()) {
    on<LoadDiaryEntries>(_onLoadDiaryEntries);
    on<AddDiaryEntry>(_onAddDiaryEntry);
    on<UpdateDiaryEntry>(_onUpdateDiaryEntry);
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
      emit(VirtualDiaryError('Gagal memuat diary: $e'));
      // Kembalikan ke state loaded dengan data sebelumnya jika ada
      if (state is VirtualDiaryLoaded) {
        emit(state as VirtualDiaryLoaded);
      }
    }
  }

  Future<void> _onAddDiaryEntry(
    AddDiaryEntry event,
    Emitter<VirtualDiaryState> emit,
  ) async {
    if (state is VirtualDiaryLoaded) {
      try {
        final newEntry = await _diaryRepository.addDiaryEntry(event.entry);
        final currentEntries = (state as VirtualDiaryLoaded).entries;
        emit(VirtualDiaryLoaded(
          entries: [newEntry, ...currentEntries],
        ));
      } catch (e) {
        emit(VirtualDiaryError('Gagal menambahkan diary: $e'));
        emit(state as VirtualDiaryLoaded); // Kembalikan ke state sebelumnya
      }
    }
  }

  Future<void> _onUpdateDiaryEntry(
    UpdateDiaryEntry event,
    Emitter<VirtualDiaryState> emit,
  ) async {
    if (state is VirtualDiaryLoaded) {
      try {
        final updatedEntry =
            await _diaryRepository.updateDiaryEntry(event.entry);
        final currentEntries = (state as VirtualDiaryLoaded).entries;

        final updatedEntries = currentEntries.map((entry) {
          return entry.id == updatedEntry.id ? updatedEntry : entry;
        }).toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        emit(VirtualDiaryLoaded(entries: updatedEntries));
      } catch (e) {
        emit(VirtualDiaryError('Gagal mengupdate diary: $e'));
        emit(state as VirtualDiaryLoaded); // Kembalikan ke state sebelumnya
      }
    }
  }

  Future<void> _onDeleteDiaryEntry(
    DeleteDiaryEntry event,
    Emitter<VirtualDiaryState> emit,
  ) async {
    if (state is VirtualDiaryLoaded) {
      try {
        await _diaryRepository.deleteDiaryEntry(event.id);
        final currentEntries = (state as VirtualDiaryLoaded).entries;
        final updatedEntries =
            currentEntries.where((entry) => entry.id != event.id).toList();
        emit(VirtualDiaryLoaded(entries: updatedEntries));
      } catch (e) {
        emit(VirtualDiaryError('Gagal menghapus diary: $e'));
        emit(state as VirtualDiaryLoaded); // Kembalikan ke state sebelumnya
      }
    }
  }
}
