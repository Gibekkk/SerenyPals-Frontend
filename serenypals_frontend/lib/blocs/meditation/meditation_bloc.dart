import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/meditation_tips.dart';
import 'mediation_event.dart';
import 'meditation_state.dart';

class MeditationTipsBloc
    extends Bloc<MeditationTipsEvent, MeditationTipsState> {
  final GetMeditationTipsUseCase _getMeditationTipsUseCase;

  MeditationTipsBloc(
      {required GetMeditationTipsUseCase getMeditationTipsUseCase})
      : _getMeditationTipsUseCase = getMeditationTipsUseCase,
        super(MeditationTipsInitial()) {
    on<LoadMeditationTips>(_onLoadMeditationTips);
  }

  void _onLoadMeditationTips(
    LoadMeditationTips event,
    Emitter<MeditationTipsState> emit,
  ) async {
    emit(MeditationTipsLoading());
    try {
      final tips = await _getMeditationTipsUseCase.execute();
      emit(MeditationTipsLoaded(tips: tips));
    } catch (e) {
      emit(MeditationTipsError(message: e.toString()));
    }
  }
}
