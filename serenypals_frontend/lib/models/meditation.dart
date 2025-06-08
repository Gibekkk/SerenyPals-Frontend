import 'package:equatable/equatable.dart';

class MeditationTip extends Equatable {
  final String title;
  final String description;

  const MeditationTip({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
