import 'package:equatable/equatable.dart';

abstract class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object> get props => [];
}

class PetInitialize extends PetEvent {}

class PetToggleMusic extends PetEvent {}

class PetStartEating extends PetEvent {}

class PetStartPlaying extends PetEvent {}

class PetStartSleeping extends PetEvent {}

class PetTick extends PetEvent {}

class PetBlink extends PetEvent {}

class PetSetIdle extends PetEvent {}
