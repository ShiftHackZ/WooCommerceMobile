import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/datasource/customer_profile_data_source.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/screens/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {

  final CustomerProfileDataSource _ds = locator<CustomerProfileDataSource>();
  final AppDb _db = locator<AppDb>();

  ProfileCubit() : super(InitialProfileState());

  void logout() async {
    emit(LoadingProfileState());
    _db.clear().then((_) {
       getProfile();
    });
  }

  void getProfile() async {
    emit(LoadingProfileState());
    var isAuthenticated = await _db.isAuthenticated();
    if (!isAuthenticated) {
      emit(NoAuthProfileState());
    } else {
      _ds.getProfile().then((profile) {
        emit(ContentProfileState(profile));
      }).catchError((error) {
        print(error.toString());
        emit(ErrorProfileState());
      });
    }
  }

  void updateProfile(
      String email,
      String firstName,
      String lastName,
      String phone,
  ) async {
    emit(LoadingProfileState());
    _ds.updateProfile(email, firstName, lastName, phone)
      .then((profile) {
        emit(CompleteProfileState(profile));
      }).catchError((error) {
        emit(ErrorProfileState());
      });
  }

  void updateShipping(
      String country,
      String city,
      String state,
      String postcode,
      String address1,
      String address2,
  ) async {
    emit(LoadingProfileState());
    _ds.updateShipping(country, city, state, postcode, address1, address2)
      .then((profile) {
        emit(CompleteProfileState(profile));
      }).catchError((error) {
        emit(ErrorProfileState());
      });
  }
}
