import 'package:equatable/equatable.dart' show Equatable;

abstract class MeditationTipsEvent extends Equatable {
  const MeditationTipsEvent();

  @override
  List<Object> get props => [];
}

class LoadMeditationTips extends MeditationTipsEvent {}
