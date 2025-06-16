import '../../models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel profile;

  ProfileLoaded(this.profile);
}
