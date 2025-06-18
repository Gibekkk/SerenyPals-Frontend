import '../../models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User profile;
  ProfileLoaded({required this.profile});
}

class ProfileUpdated extends ProfileState {
  final User user;
  ProfileUpdated(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
