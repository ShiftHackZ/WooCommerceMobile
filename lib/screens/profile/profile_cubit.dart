import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wooapp/database/database.dart';
import 'package:wooapp/datasource/customer_profile_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/customer_profile.dart';
import 'package:wooapp/screens/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final CustomerProfileDataSource _ds = locator<CustomerProfileDataSource>();
  final AppDb _db = locator<AppDb>();

  CustomerProfile? _profile;

  ProfileCubit() : super(InitialProfileState()) {
    getProfile();
  }

  void logout() async {
    emit(LoadingProfileState());
    _profile = null;
    _db.clear().then((_) => getProfile());
  }

  void onTabOpened() async {
    getProfile();
  }

  void forceRefreshProfile() {
    _profile = null;
    getProfile();
  }

  void getProfile() async {
    if (_profile == null) emit(LoadingProfileState());
    var isAuthenticated = await _db.isAuthenticated();
    if (!isAuthenticated) {
      emit(NoAuthProfileState());
    } else {
      _ds.getProfile().then((profile) {
        _profile = profile;
        emit(ContentProfileState(profile));
      }).catchError((error) {
        if (_profile != null) {
          ContentProfileState(_profile!);
        } else {
          emit(ErrorProfileState());
        }
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
