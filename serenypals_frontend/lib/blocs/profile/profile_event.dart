abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final String token;
  FetchProfile(this.token);
}

class UpdateProfile extends ProfileEvent {
  final String token;
  final Map<String, dynamic> updatedData;
  UpdateProfile({required this.token, required this.updatedData});
}
