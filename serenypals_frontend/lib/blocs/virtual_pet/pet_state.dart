import 'package:equatable/equatable.dart';

import '../../models/pet.dart';

class PetState extends Equatable {
  final Pet pet;
  final String currentTrackName;
  final String statusMessage;

  const PetState({
    required this.pet,
    this.currentTrackName = '',
    this.statusMessage = '',
  });

  PetState copyWith({
    Pet? pet,
    String? currentTrackName,
    String? statusMessage,
  }) {
    return PetState(
      pet: pet ?? this.pet,
      currentTrackName: currentTrackName ?? this.currentTrackName,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  List<Object?> get props => [pet, currentTrackName, statusMessage];
}
