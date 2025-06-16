import '../../models/user.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel updatedProfile;

  UpdateProfile(this.updatedProfile);
}
