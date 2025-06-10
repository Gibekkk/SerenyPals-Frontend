import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String name;
  final String currentAnimation;
  final double energy;
  final double hunger;
  final int consecutiveCriticalTicks;
  final bool isMusicPlaying;
  final bool hasUserInteractedWithMusicToggle;
  final bool isBlinking;

  const Pet({
    this.name = 'Bleki',
    this.currentAnimation = 'idle',
    this.energy = 100,
    this.hunger = 100,
    this.consecutiveCriticalTicks = 0,
    this.isMusicPlaying = false,
    this.hasUserInteractedWithMusicToggle = false,
    this.isBlinking = false,
  });

  bool get isAngry => consecutiveCriticalTicks >= 5;
  bool get isHungry => hunger <= 0;
  bool get isTired => energy <= 0;

  Pet copyWith({
    String? name,
    String? currentAnimation,
    double? energy,
    double? hunger,
    int? consecutiveCriticalTicks,
    bool? isMusicPlaying,
    bool? hasUserInteractedWithMusicToggle,
    bool? isBlinking,
  }) {
    return Pet(
      name: name ?? this.name,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      energy: energy ?? this.energy,
      hunger: hunger ?? this.hunger,
      consecutiveCriticalTicks:
          consecutiveCriticalTicks ?? this.consecutiveCriticalTicks,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
      hasUserInteractedWithMusicToggle: hasUserInteractedWithMusicToggle ??
          this.hasUserInteractedWithMusicToggle,
      isBlinking: isBlinking ?? this.isBlinking,
    );
  }

  @override
  List<Object> get props => [
        name,
        currentAnimation,
        energy,
        hunger,
        consecutiveCriticalTicks,
        isMusicPlaying,
        hasUserInteractedWithMusicToggle,
        isBlinking,
      ];
}
