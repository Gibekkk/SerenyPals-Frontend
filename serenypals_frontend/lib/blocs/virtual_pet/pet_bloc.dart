import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:serenypals_frontend/blocs/virtual_pet/pet_event.dart';
import '../../models/pet.dart';
import 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final AudioPlayer _bgMusicPlayer = AudioPlayer();
  Timer? _statusTimer;
  Timer? _blinkTimer;
  final List<String> _playlist = [
    'assets/audio/background_music.mp3',
    'assets/audio/background_music2.mp3',
  ];
  int _currentTrackIndex = 0;

  PetBloc() : super(PetState(pet: const Pet(), currentTrackName: '')) {
    on<PetInitialize>(_onInitialize);
    on<PetToggleMusic>(_onToggleMusic);
    on<PetStartEating>(_onStartEating);
    on<PetStartPlaying>(_onStartPlaying);
    on<PetStartSleeping>(_onStartSleeping);
    on<PetTick>(_onTick);
    on<PetBlink>(_onBlink);
    on<PetSetIdle>(_onSetIdle);

    add(PetInitialize());
  }

  Future<void> _onInitialize(
      PetInitialize event, Emitter<PetState> emit) async {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(PetTick());
    });

    try {
      await _bgMusicPlayer.setVolume(0.5);
      await _bgMusicPlayer.setAsset(_playlist[_currentTrackIndex]);
      await _bgMusicPlayer.play();

      _bgMusicPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _playNextTrack(emit);
        }
      });

      emit(state.copyWith(
        pet: state.pet.copyWith(
          isMusicPlaying: true,
          hasUserInteractedWithMusicToggle: true,
        ),
        currentTrackName: _playlist[_currentTrackIndex],
      ));
    } catch (e) {
      debugPrint('Error auto-playing music: $e');
      emit(state.copyWith(statusMessage: 'Failed to start music'));
    }

    if (state.pet.isAngry) {
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        add(PetBlink());
      });
    }
  }

  Future<void> _playNextTrack(Emitter<PetState> emit) async {
    _currentTrackIndex = (_currentTrackIndex + 1) % _playlist.length;
    try {
      await _bgMusicPlayer.setAsset(_playlist[_currentTrackIndex]);
      await _bgMusicPlayer.play();

      emit(state.copyWith(currentTrackName: _playlist[_currentTrackIndex]));
    } catch (e) {
      debugPrint('Error switching to next track: $e');
    }
  }

  Future<void> _onToggleMusic(
    PetToggleMusic event,
    Emitter<PetState> emit,
  ) async {
    debugPrint(
        "ToggleMusic called: isMusicPlaying=${state.pet.isMusicPlaying}");
    try {
      if (state.pet.isMusicPlaying) {
        await _bgMusicPlayer.pause();
        debugPrint("Music paused.");
        emit(state.copyWith(
          pet: state.pet.copyWith(isMusicPlaying: false),
        ));
      } else {
        await _bgMusicPlayer.setAsset(_playlist[_currentTrackIndex]);
        await _bgMusicPlayer.play();
        debugPrint("Music started.");
        emit(state.copyWith(
          pet: state.pet.copyWith(isMusicPlaying: true),
        ));
      }
    } catch (e) {
      debugPrint("Error toggling music: $e");
      emit(state.copyWith(statusMessage: 'Failed to toggle music'));
    }
  }

  void _onSetIdle(PetSetIdle event, Emitter<PetState> emit) {
    debugPrint("Set animation to idle");
    emit(state.copyWith(
      pet: state.pet.copyWith(currentAnimation: 'idle'),
    ));
  }

  void _onStartEating(PetStartEating event, Emitter<PetState> emit) {
    emit(state.copyWith(
      pet: state.pet.copyWith(
        currentAnimation: 'eating',
        hunger: (state.pet.hunger + 20).clamp(0, 100),
        consecutiveCriticalTicks: 0,
      ),
    ));

    Future.delayed(const Duration(seconds: 2), () {
      add(PetSetIdle());
    });
  }

  void _onStartPlaying(PetStartPlaying event, Emitter<PetState> emit) {
    emit(state.copyWith(
      pet: state.pet.copyWith(
        currentAnimation: 'playing',
        energy: (state.pet.energy - 15).clamp(0, 100),
        hunger: (state.pet.hunger - 10).clamp(0, 100),
        consecutiveCriticalTicks: 0,
      ),
    ));

    Future.delayed(const Duration(seconds: 5), () {
      add(PetSetIdle());
    });
  }

  void _onStartSleeping(PetStartSleeping event, Emitter<PetState> emit) {
    emit(state.copyWith(
      pet: state.pet.copyWith(
        currentAnimation: 'sleeping',
        energy: (state.pet.energy + 30).clamp(0, 100),
        consecutiveCriticalTicks: 0,
      ),
    ));

    Future.delayed(const Duration(seconds: 7), () {
      add(PetSetIdle());
    });
  }

  void _onTick(PetTick event, Emitter<PetState> emit) {
    final newHunger = (state.pet.hunger - 0.5).clamp(0, 100);
    final newEnergy = (state.pet.energy - 0.3).clamp(0, 100);

    final wasCritical = (state.pet.hunger <= 0 || state.pet.energy <= 0);
    final newConsecutiveTicks =
        wasCritical ? state.pet.consecutiveCriticalTicks + 1 : 0;

    final newPet = state.pet.copyWith(
      hunger: newHunger.toDouble(),
      energy: newEnergy.toDouble(),
      consecutiveCriticalTicks: newConsecutiveTicks,
    );

    emit(state.copyWith(pet: newPet));

    if (newPet.isAngry && _blinkTimer == null) {
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        add(PetBlink());
      });
    } else if (!newPet.isAngry && _blinkTimer != null) {
      _blinkTimer?.cancel();
      _blinkTimer = null;
      emit(state.copyWith(
        pet: newPet.copyWith(isBlinking: false),
      ));
    }
  }

  void _onBlink(PetBlink event, Emitter<PetState> emit) {
    emit(state.copyWith(
      pet: state.pet.copyWith(isBlinking: !state.pet.isBlinking),
    ));
  }

  @override
  Future<void> close() {
    _statusTimer?.cancel();
    _blinkTimer?.cancel();
    _bgMusicPlayer.dispose();
    return super.close();
  }
}
