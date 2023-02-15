import 'package:wooapp/model/customer_profile.dart';

abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class ContentProfileState extends ProfileState {
  final CustomerProfile profile;

  ContentProfileState(this.profile);
}

class NoAuthProfileState extends ProfileState {}

class ErrorProfileState extends ProfileState {}

class CompleteProfileState extends ProfileState {
  final CustomerProfile profile;

  CompleteProfileState(this.profile);
}
