import 'package:flutter_bloc/flutter_bloc.dart';
// Hapus import yang tidak lagi diperlukan jika GetMeditationTipsUseCase dihapus:
// import '../../utils/meditation_tips.dart';
import 'mediation_event.dart';
import 'meditation_state.dart';
import '../../repositories/meditation_repository.dart'; // Import MeditationRepository

class MeditationTipsBloc
    extends Bloc<MeditationTipsEvent, MeditationTipsState> {
  // Ubah tipe dari GetMeditationTipsUseCase menjadi MeditationRepository
  final MeditationRepository _meditationRepository;

  MeditationTipsBloc({
    required MeditationRepository meditationRepository,
  })  : _meditationRepository = meditationRepository,
        super(MeditationTipsInitial()) {
    on<LoadMeditationTips>(_onLoadMeditationTips);
  }

  void _onLoadMeditationTips(
    LoadMeditationTips event,
    Emitter<MeditationTipsState> emit,
  ) async {
    emit(MeditationTipsLoading());
    try {
      // Panggil method dari _meditationRepository untuk mendapatkan tips
      final tips = await _meditationRepository.getMeditationTips();
      emit(MeditationTipsLoaded(tips: tips));
    } catch (e) {
      emit(MeditationTipsError(message: e.toString()));
    }
  }
}
