import 'package:equatable/equatable.dart';

import '../../models/meditation.dart';

abstract class MeditationTipsState extends Equatable {
  const MeditationTipsState();

  @override
  List<Object> get props => [];
}

class MeditationTipsInitial extends MeditationTipsState {}

class MeditationTipsLoading extends MeditationTipsState {}

class MeditationTipsLoaded extends MeditationTipsState {
  final List<MeditationTip> tips;

  const MeditationTipsLoaded({required this.tips});

  @override
  List<Object> get props => [tips];
}

class MeditationTipsError extends MeditationTipsState {
  final String message;

  const MeditationTipsError({required this.message});

  @override
  List<Object> get props => [message];
}
