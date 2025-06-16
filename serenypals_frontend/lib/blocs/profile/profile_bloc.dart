import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) {
      emit(ProfileLoaded(UserModel(
        name: 'Adom Shafi',
        email: 'hellobesnik@gmail.com',
        phone: '+880-1704-889-390',
        birthDate: '1/11/2000',
      )));
    });

    on<UpdateProfile>((event, emit) {
      emit(ProfileLoaded(event.updatedProfile));
    });
  }
}
